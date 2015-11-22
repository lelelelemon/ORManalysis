
$graph_file = nil

$last_caller_string = ""
$QUERY_COLOR = "orange"
$FLOWEDGE_COLOR = "blue"

$label = ""
$l_index = 0
$blank = ""
#TODO: a lot of duplicated code

def handle_single_call_node(start_class, start_function, class_handler, call, level, simplified_caller=nil)
		callerv_name = call.findCaller(start_class, start_function)
		callerv = $class_map[callerv_name]
		pass_params = ""
		pass_returnv = ""
		call.getParams.each do |param|
			if param.getVar.length > 0
					pass_params += "#{param.getVar}, "
			end
		end
		pass_returnv = call.getReturnValue
		if call.isQuery
			caller_class = nil
			if class_handler.getMethodVarMap[start_function] != nil
				caller_class = class_handler.getMethodVarMap[start_function].search_var(call.getObjName)
			end
			if caller_class == nil
				caller_class = call.getTableName
			end

			#if trigger_save?(call)
				#puts "#{$blank}=====transaction begin====="
			#end

			puts "#{$blank}\tlevel #{(level+1)}:  [QUERY] #{call.getObjName} . #{call.getFuncName}	{params: #{pass_params}} # {returnv: #{pass_returnv}} # {op: #{caller_class}.#{call.getQueryType}}"
			if simplified_caller != nil
				$label += "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\" bgcolor=\"#{$QUERY_COLOR}\"> [QUERY]#{simplified_caller}.#{call.getFuncName} </td></tr>\n"
			else
				$label += "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\" bgcolor=\"#{$QUERY_COLOR}\"> [QUERY]#{call.getObjName}.#{call.getFuncName} </td></tr>\n"
			end
			$l_index += 1

			if trigger_save?(call)
				if caller_class != nil
					$class_map[caller_class].getSave.each do |save_action|
						temp_name = "#{caller_class}.#{save_action.getFuncName}"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)

							$last_caller_string = "#{start_class}_#{simplify(start_function)}_BB1:f#{$l_index-1}"

							trace_flow(caller_class, save_action.getFuncName, "", "", level+2)
						end
					end
				end
				#puts "#{$blank}=====transaction end====="
			end

		elsif callerv != nil
			temp_name = "#{callerv_name}.#{call.getFuncName}"
			$label +=  "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\"> #{temp_name}</td></tr>\n"
			$l_index += 1

			if $non_repeat_list.include?(temp_name) == false
				if is_repeatable_function(call.getFuncName)==false
					$non_repeat_list.push(temp_name)
				end

				$last_caller_string = "#{start_class}_#{simplify(start_function)}_BB1:f#{$l_index-1}"

				trace_flow(callerv_name, call.getFuncName, pass_params, pass_returnv, level+1)
			end
		end
end

def set_node_label(start_class, start_function, bb_index)
		$label = $label + "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\"> (nil) </td></tr>\n"		
		$label = "\t\tlabel = <<table border=\"2\">\n#{$label}\n\t\t</table>>\n"
		$label = "\t#{start_class}_#{simplify(start_function)}_BB#{bb_index} [\n" + $label
		$label = $label + "\t\tshape = none\n"
		$label = $label + "\t];\n"
end


def handle_single_bb(start_class, start_function, class_handler, bb, label_list, function_handler, level)

	$lable = ""
	$l_index = 0

	if bb.instance_of?Basic_block
		bb.getInstr.each do |instr|
			
			if instr.instance_of?Call_instr
				#match instr's call to funccall in Method_class
				call = call_match_name(instr.getResolvedCaller, instr.getFuncname, function_handler)
				#if call == nil
				#	puts "Name doesn't match: #{instr.toString}" 
				#end
				if call != nil

					#puts "Map to #{call.getObjName}.#{call.getFuncName}"
					#print "\t -- "
					#call.print
					
					if instr.getResolvedCaller.length > 0
						handle_single_call_node(start_class, start_function, class_handler, call, level, instr.getResolvedCaller)
					else
						handle_single_call_node(start_class, start_function, class_handler, call, level)				
					end
	
				end
			end
		end
			
		set_node_label(start_class, start_function, bb.getIndex)			
		bb.setLabelN($l_index)			
	
		label_list.push($label)

	elsif bb.instance_of?Closure
		bb.getBB.each do |inner_bb|
			handle_single_bb(start_class, start_function, class_handler, inner_bb, label_list, function_handler, level)
		end
	end

end

def write_single_bb(start_class, start_function, bb)
	if bb.instance_of?Basic_block
		bb.getOutgoings.each do |to_bb|
			from_bb_name = "#{start_class}_#{simplify(start_function)}_BB#{bb.getIndex}"
			to_bb_name = "#{start_class}_#{simplify(start_function)}_BB#{to_bb}"
			$graph_file.write("\t#{from_bb_name}:f#{bb.getLabelN} -> #{to_bb_name}:f0 [ color=#{$FLOWEDGE_COLOR} ];\n")
		end
	elsif bb.instance_of?Closure
		bb.getBB.each do |inner_bb|
			write_single_bb(start_class, start_function, inner_bb)
		end
	end
end


def trace_flow(start_class, start_function, params, returnv, level)
	class_handler = $class_map[start_class]
	function_handler = class_handler.getMethods[start_function]

	$blank = ""
	for i in (0...level)
		$blank = $blank + "\t"
	end

	if function_handler == nil
		if is_transaction_function(start_function)
			if start_function.include?("begin")
				puts "#{$blank}======transaction begin====="
			else
				puts "#{$blank}======transaction end====="
			end
		end
		#puts "function #{start_class}.#{start_function} cannot be found"
		return 
	end	

	#$graph_file.write("subgraph cluster_#{start_class}_#{start_function}")

	#handles before_filter
	before_filter_name = "#{start_class}.before_filter"
	if $non_repeat_list.include?(before_filter_name) == false
		$non_repeat_list.push(before_filter_name)

		trace_flow(start_class, "before_filter", "", "", level)
	end

	puts "#{$blank}level #{level}: #{start_class} . #{start_function} (params: #{params}) # (returnv: #{returnv})"

	if $last_caller_string.length > 0	
		_to_name = "#{start_class}_#{simplify(start_function)}_BB1" 
		$graph_file.write("#{$last_caller_string} -> #{_to_name} [label = \"#{params}\"]; \n")
		if returnv.length > 0
			$graph_file.write("#{_to_name} -> #{$last_caller_string} [label = \"r: (#{returnv})\"]; \n")
		end
	end
	
	label_list = Array.new

	if function_handler.getCFG != nil
		function_handler.getCFG.getBB.each do |bb|
				
				handle_single_bb(start_class, start_function, class_handler, bb, label_list, function_handler, level)
			
		end

	#Function is not specifically defined, like .new .valid?, etc
	else

		$label = ""
		$l_index = 0

		function_handler.getCalls.each do |call|
		
			handle_single_call_node(start_class, start_function, class_handler, call, level)

		end	
	
		set_node_label(start_class, start_function, 1)
		
		label_list.push($label)
		
	end

	#puts "#{$blank}level #{level}: #{start_class} . #{start_function} (params: #{params}) # (returnv: #{returnv})"
	#puts "#{$blank}(write subgraph #{start_class}_#{start_function})"

	$graph_file.write("subgraph cluster_#{start_class}_#{simplify(start_function)} {\n")
	$graph_file.write("\tcolor=red;\n\tnode [style=filled];\n\tlabel = \"#{start_class}_#{start_function}\"\n")	
	label_list.each do |label|
		$graph_file.write("#{label}")
	end

	if function_handler.getCFG != nil	
		function_handler.getCFG.getBB.each do |bb|
			write_single_bb(start_class, start_function, bb)
		end
	end	

	$graph_file.write("}\n")
end
