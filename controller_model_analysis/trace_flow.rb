
$graph_file = nil

$last_caller_string = ""
$QUERY_COLOR = "orange"
$FLOWEDGE_COLOR = "blue"

$label = ""
$l_index = 0
$label_stack = Array.new
$l_index_stack = Array.new
$blank = ""
$in_view = false

$closure_stack = Array.new

def get_closure_tag
	r = ""
	i = 0
	if $closure_stack.length > 0
		r += "#{$closure_stack[-1].getRand}"
	end
	r += "_"
	$closure_stack.each do |c|
		r += "closure#{i}_"
		i += 1
	end
	return r
end
#TODO: a lot of duplicated code

def handle_single_call_node(start_class, start_function, class_handler, call, level, bb_index, simplified_caller=nil)
		#callerv_name = call.findCaller(start_class, start_function)
		#callerv = $class_map[callerv_name]
		#pre-computed after reading all files, in #read_file.rb
		callerv = call.caller
		pass_params = ""
		pass_returnv = ""
		call.getParams.each do |param|
			if param.getVar.length > 0
					pass_params += "#{param.getVar}, "
			end
		end
		pass_returnv = call.getReturnValue
		if call.isQuery
			caller_class = ""
			if callerv != nil
				caller_class = callerv.getName
			end
			if trigger_save?(call) or trigger_create?(call)
				puts "=====transaction begin====="
			end

			$blank = ""
			for i in (0...level)
				$blank = $blank + "\t"
			end

			puts "#{$blank}\tlevel #{(level+1)}:  [QUERY] #{call.getObjName} . #{call.getFuncName}	{params: #{pass_params}} # {returnv: #{pass_returnv}} # {op: #{caller_class}.#{call.getQueryType}}"
			if simplified_caller != nil
				$label += "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\" bgcolor=\"#{$QUERY_COLOR}\"> [QUERY]#{simplified_caller}.#{call.getFuncName} </td></tr>\n"
			else
				$label += "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\" bgcolor=\"#{$QUERY_COLOR}\"> [QUERY]#{remove_special_chars(call.getObjName)}.#{call.getFuncName} </td></tr>\n"
			end
			$l_index += 1

			if trigger_save?(call) or trigger_create?(call)
				if callerv != nil and trigger_save?(call)
						#TODO: here we assume validation associate with 
						temp_name = "#{callerv.getName}.before_save"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)

							$last_caller_string = "#{start_class}_before_save_#{get_closure_tag}BB#{bb_index}:f#{$l_index-1}"
					
							$label_stack.push($label)
							$l_index_stack.push($l_index)
							trace_flow(callerv.getName, "before_save", "", "", level+2)
							$label = $label_stack.pop
							$l_index = $l_index_stack.pop
						end

						temp_name = "#{callerv.getName}.before_validation"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)

							$last_caller_string = "#{start_class}_before_validation_#{get_closure_tag}BB#{bb_index}:f#{$l_index-1}"
					
							$label_stack.push($label)
							$l_index_stack.push($l_index)
							trace_flow(callerv.getName, "before_validation", "", "", level+2)
							$label = $label_stack.pop
							$l_index = $l_index_stack.pop
						end

				end
				
				if callerv != nil and trigger_create?(call)
						temp_name = "#{callerv.getName}.before_create"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)
							
							$last_caller_string = "#{start_class}_before_create_#{get_closure_tag}BB#{bb_index}:f#{$l_index-1}"
							
							$label_stack.push($label)
							$l_index_stack.push($l_index)
							trace_flow(callerv.getName, "before_create", "", "", level+2)
							$label = $label_stack.pop
							$l_index = $l_index_stack.pop
						end
				end
				puts "=====transaction end====="
			end

		#elsif call.isField
		#	puts "#{$blank}\tlevel #{(level+1)}:  +FIELD+ #{callerv.getName} . #{call.getFuncName}	(type: #{call.getField.type}) "

		elsif callerv != nil
			temp_name = "#{callerv.getName}.#{call.getFuncName}"

			$label +=  "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\"> #{temp_name}</td></tr>\n"
			$l_index += 1

			if $non_repeat_list.include?(temp_name) == false
				if is_repeatable_function(call.getFuncName)==false
					$non_repeat_list.push(temp_name)
				end

				$last_caller_string = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{bb_index}:f#{$l_index-1}"

				$label_stack.push($label)
				$l_index_stack.push($l_index)
				trace_flow(callerv.getName, call.getFuncName, pass_params, pass_returnv, level+1)
				$label = $label_stack.pop
				$l_index = $l_index_stack.pop
			end
		end
end

def set_node_label(start_class, start_function, bb, label_list)
		$label = $label + "\t\t\t<tr><td port=\"f#{$l_index}\" border=\"1\"> (nil) </td></tr>\n"		
		$label = "\t\tlabel = <<table border=\"2\">\n#{$label}\t\t</table>>\n"

		if bb == nil #No CFG found
			$label = "\t#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB1 [\n" + $label
		else
			$label = "\t#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{bb.getIndex} [\n" + $label
		end

		$label = $label + "\t\tshape = none\n"

		#view output/rendering
		if bb != nil and bb.getCFG.instance_of?Closure and bb.getCFG.getViewCode
			$label = $label + "\t\tcolor = pink\n"
		end
		#include "param", from user input
		if bb != nil 
			include_user_input = false
			bb.getInstr.each do |ins|
				if ins.getFromUserInput
					include_user_input = true
				end
			end
			if include_user_input
				$label = $label + "\t\tcolor = green\n"
			end
		end
		
		$label = $label + "\t];\n"

		label_list.push($label)		
end

def handle_single_bb(start_class, start_function, class_handler, bb, label_list, function_handler, level)
	$label = ""
	$l_index = 0
	bb.getInstr.each do |instr|
		handle_single_instr(start_class, start_function, class_handler, bb, instr, label_list, function_handler, level)
	end

	set_node_label(start_class, start_function, bb, label_list)			
	bb.setLabelN($l_index)			
end

def handle_single_instr(start_class, start_function, class_handler, bb, instr, label_list, function_handler, level)

	instr.setFTag($l_index)
	if instr.instance_of?Call_instr
		#match instr's call to funccall in Method_class
		call = call_match_name(instr.getResolvedCaller, instr.getFuncname, function_handler)
		#if call == nil
		#	puts "Name doesn't match: #{instr.toString}" 
		#else
		#	puts "match call: #{instr.toString}"
		#end
		if call != nil

			#puts "Map to #{call.getObjName}.#{call.getFuncName}"
			#print "\t -- "
			#call.print
		
			if instr.getResolvedCaller.length > 0
				handle_single_call_node(start_class, start_function, class_handler, call, level, bb.getIndex, instr.getResolvedCaller)
			else
				handle_single_call_node(start_class, start_function, class_handler, call, level, bb.getIndex)				
			end
	
		end
	end
		
	if instr.hasClosure?
		cl = instr.getClosure
		$l_index_stack.push($l_index)	
		$closure_stack.push(cl)
		$label_stack.push($label)
		cl.getBB.each do |inner_bb|
			handle_single_bb(start_class, start_function, class_handler, inner_bb, label_list, function_handler, level)
		end
		$closure_stack.pop
		$l_index = $l_index_stack.pop
		$label = $label_stack.pop
	end

end

def write_single_bb(start_class, start_function, bb)
	from_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{bb.getIndex}"
	
	bb.getOutgoings.each do |to_bb|
		to_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{to_bb}"
		$graph_file.write("\t#{from_bb_name} -> #{to_bb_name} [ color=#{$FLOWEDGE_COLOR} ];\n")
	end

	index = 0
	bb.getInstr.each do |instr|
		if instr.hasClosure?
			cl = instr.getClosure
			$closure_stack.push(cl)
			to_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB1"
			to_end_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{cl.getLastBB.getIndex}"
			$graph_file.write("\t#{from_bb_name}:f#{instr.getFTag} -> #{to_bb_name} [color=#{$FLOWEDGE_COLOR} ];\n")
			$graph_file.write("\t#{to_end_bb_name}:f0 -> #{from_bb_name} [color=#{$FLOWEDGE_COLOR} ];\n")

			cl.getBB.each do |inner_bb|
				write_single_bb(start_class, start_function, inner_bb)
			end
			cl_last_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{cl.getBB[-1].getIndex}"
			cl_first_bb_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB#{cl.getBB[0].getIndex}"
			$graph_file.write("\t#{cl_last_bb_name} -> #{cl_first_bb_name} [color=#{$FLOWEDGE_COLOR} ];\n")

			$closure_stack.pop
		end
		index = index + 1
	end
end


def trace_flow(start_class, start_function, params, returnv, level)
	class_handler = $class_map[start_class]
	if class_handler == nil
		puts "Class handler not found: #{start_class}"
	end
	function_handler = class_handler.getMethod(start_function)

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
		else
			#puts "function #{start_class}.#{start_function} cannot be found"
			return 
		end
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
		_to_name = "#{start_class}_#{simplify(start_function)}_#{get_closure_tag}BB1" 
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

		#puts "#{start_class}.#{start_function} is not matched"
		$label = ""
		$l_index = 0

		function_handler.getCalls.each do |call|
			handle_single_call_node(start_class, start_function, class_handler, call, level, 1)

		end
		set_node_label(start_class, start_function, nil, label_list)
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
