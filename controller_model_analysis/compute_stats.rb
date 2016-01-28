$QNODECOLOR = "coral1"
$USERINOUTCOLOR = "cyan3"


#backward
$query_depends_on = Array.new
#forward
$query_determines = Array.new
#backward
$query_depends_on_cflow = Array.new
#forward
$query_determines_cflow = Array.new

def traceback_data_dep(cur_node, stop_at_query=false)
	@dep_array = Array.new
	@node_list = Array.new
	@node_list.push(cur_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		node.getBackwardEdges.each do |e|
			if e.getFromNode != nil and e.getToNode != nil
				if e.getFromNode.isReadQuery?
					@dep_array.push(e.getFromNode)
					if stop_at_query
						return e.getFromNode
					end	
				else
					#If the from node is in cur_node's call stack and the data dependency is a return value, the dependent node can be
					#instructions far after cur_node
					if cur_node.getCallStack.include?(e.getToNode) and e.getVname == "returnv"
					elsif e.getFromNode.getIndex < cur_node.getIndex
					#else
						#test is both nodes are in the same basic block, prevent from tracing too far
						#if e.getFromNode.getInstr.getBB == node.getInstr.getBB
						if @node_list.include?(e.getFromNode) == false and @dep_array.include?(e.getFromNode) == false
							@dep_array.push(e.getFromNode)
							@node_list.push(e.getFromNode)
						end
					end
				end
			elsif e.getFromNode == nil and e.getToNode != nil
				#TODO: this is a bit annoying... if the type in @dep_array is Edge, then it is user input, otherwise other instruction nodes
				@dep_array.push(e)
			end
		end
	end
	if stop_at_query
		return nil
	else
		return @dep_array
	end
end

#for a query, if it is like the form v = Vote.where(...)
#Given the query instruction Vote.where
#return the assign instruction v =
#so that we can know the result of the query is put into the variable v
#Or it can be like if Vote.where(...)
#Stops at a nearest var define or branch instr
#TODO: any other possiblilities?
def find_nearest_var(cur_node)
	@node_list = Array.new
	@node_list.push(cur_node)
	@traversed = Array.new
	while @node_list.length > 0 do
		node = @node_list.pop
		@traversed.push(node)
		node.getDataflowEdges.each do |e|
			if e.getToNode.getInstr.getDefv != nil 
				if e.getToNode.getInstr.getDefv.include?('%') == false
					return e.getToNode
				#elsif e.getToNode.getInstr.getDefv.include?("self")
				#	return e.getToNode
				end
			elsif e.getToNode.getInstr.instance_of?AttrAssign_instr and e.getToNode.getInstr.getCaller.include?("self")
				return e.getToNode
			else
				if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
					if e.getToNode.getInstr.getBB == cur_node.getInstr.getBB
						@node_list.push(e.getToNode)
					end
				end
			end
		end
	end
	return nil
end

def traceforward_data_dep(query_node)
	@traversed = Array.new
	@node_list = Array.new
	@node_list.push(query_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		@traversed.push(node)
		node.getDataflowEdges.each do |e|
			#e.getToNode will never be nil
			#if e.getToNode.isField?
			#	#check caller name matches
			#	var_name = e.getToNode.getInstr.getCallHandler.getObjName
			#	f_name = e.getToNode.getInstr.getCallHandler.getFuncName
			#	if (self_v_name == nil or self_v_name != var_name) and e.getToNode.getInstr.instance_of?AttrAssign_instr
			#		@traversed.push(e.getToNode)
			#	else
			#		if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
			#			@node_list.push(e.getToNode)
			#		end	
			#	end
			#	#puts "\t* Field #{var_name} . #{f_name} is being used"
			#	#cur_node must define sth
			#	#if cur_node.getDefv == var_name
			#		#puts "#{var_name} . #{e.getToNode.getInstr.getCallHandler.getFuncName} from [query] #{query_node.getInstr.toString} is used"
			#	#end
			if e.getToNode.getInView
				@traversed.push(e.getToNode)
			elsif e.getToNode.isQuery? and e.getToNode != query_node
				@traversed.push(e.getToNode)
				@node_list.push(e.getToNode)
			else
				#If it is a return value dep, the ToNode (funccall node), will not pass any data dep to other node within this func call
				#if node.getCallStack.include?(e.getToNode) and e.getVname == "returnv"
				#	@traversed.push(e.getToNode)
				#	e.getToNode.getDataflowEdges.each do |e1|
				#		next_node = e1.getToNode
				#		if e1.getToNode.getIndex > query_node.getIndex and @node_list.include?(e1.getToNode) == false and @traversed.include?(e1.getToNode) == false
				#			@node_list.push(e1.getToNode)
				#		end
				#	end
				#else
					if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
						if e.getToNode.getIndex > query_node.getIndex or e.getVname == "returnv"
							@node_list.push(e.getToNode)
						end
					end	
				#end
			end
		end
	end
	@traversed.shift
	return @traversed
end

def print_dataflow_graph
	$node_list.each do |n|
		print "Node #{n.getIndex}: "
		n.getDataflowEdges.each do |d|
			print "n#{d.getToNode.getIndex}, "
		end
		puts ""
	end
end

def construct_query_graph
	$node_list.each do |n1|
		if n1.isQuery?
			$node_list.each do |n2|
				if n2.isQuery?
					connected = false
					$global_check = Hash.new
					if is_directly_connected(n1, n2)
						graph_write($graph_file, "n#{n1.getIndex} -> n#{n2.getIndex}\n")
					end
				end
			end
		end
	end		
end

def print_query_graph(output_dir, start_class, start_function)

	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_Qgraph.log"
	$graph_file = File.open(graph_fname, "w");

	graph_write($graph_file, "digraph #{remove_special_chars(start_class)}_#{start_function} {\n")
	print_graph2(start_class, start_function)
	graph_write($graph_file, "}");

	$graph_file.close
end

def print_graph2(start_class, start_function)
	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end

	#$graph_file.write
	#traverse_instr_tree($root, 0)

	#start constructing query graph	
	construct_query_graph
	$node_list.each do |n|
		if n.isQuery?
			if n.getInClosure == false
				graph_write($graph_file, "\tn#{n.getIndex} [label=<<i>#{n.getLabel}</i>>]; \n")
			else
				graph_write($graph_file, "\tn#{n.getIndex} [label=<<i>#{n.getLabel}</i>> style=filled color=orange]; \n")
			end
		end
	end
	##end constructing query graph

	#print_dataflow_graph

	#$node_list.each do |n|
	#	print "node #{n.getIndex}: "
	#	n.getChildren.each do |c|
	#		print "#{c.getIndex}, "
	#	end
	#	puts ""
	#end
end

$computed_node = nil
$cnt_depends_on = 0
$cnt_determines = 0
$cnt_depends_on_cflow = 0
$cnt_determines_cflow = 0

def compute_dataflow_stat(output_dir, start_class, start_function, random=false)

	if $root == nil and random == false
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		addAllControlEdges
		compute_source_sink_for_all_nodes
		if $cfg == nil
			return
		end
		$root = $cfg.getBB[0].getInstr[0].getINode	
	elsif random == true
		if $root == nil
			random_trace(start_class, start_function)
		end
	end
	
	$node_list.each do |n|
		n.setLabel
		puts "#{n.getIndex}:#{n.getInstr.toString}"
		n.getBackwardEdges.each do |e|
			if e.getFromNode != nil
				puts "\t\t (#{e.getVname})<- #{e.getFromNode.getIndex}: #{e.getFromNode.getInstr.toString}"
			else
				#puts "\t\t <- params"
			end
		end
		#n.getControlflowEdges.each do |e|
		#	puts "\t\t -> #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString}"
		#end
		#puts "#{n.getIndex}: #{n.getInstr.toString}"
	end


	puts "Finish string printing"
	graph_fname = "#{output_dir}/sketch_graph.log"
	$graph_file = File.open(graph_fname, "w")

	build_sketch_graph

	$graph_file.close

	compute_functional_dependency
	#graph_fname = "#{output_dir}/sketch_stats.txt"
	#$graph_file = File.open(graph_fname, "w")

	#compute_chain_stats

#	graph_fname = "#{output_dir}/backward_forward.log"
#	$graph_file = File.open(graph_fname, "w")

	
#	$node_list.each do |n|
#		if n.isQuery?
#			$cnt_depends_on = 0
#			$cnt_determines = 0
#			$cnt_depends_on_cflow = 0
#			$cnt_determines_cflow = 0
#			compute_dataflow_forward(output_dir, start_class, start_function, n)
#			compute_dataflow_backward(output_dir, start_class, start_function, n)
#			$query_depends_on.push($cnt_depends_on)
#			$query_determines.push($cnt_determines)
#			$query_depends_on_cflow.push($cnt_depends_on_cflow)
#			$query_determines_cflow.push($cnt_determines_cflow)
#			#puts "#{n.getInstr.toString}"
#			#puts "cnt_depends_on = #{$cnt_depends_on}"
#			#puts "cnt_determins = #{$cnt_determines}"
#		end
#	end


	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_stats.txt"
	$graph_file = File.open(graph_fname, "w");

	total_query_num = 0
	query_in_closure = 0
	query_in_view = 0
	query_read = 0
	query_write = 0
	branch_dependon_query = 0
	total_branch = 0

	cnt_materialized_query = 0	

	write_source_total = 0	
	write_from_const = 0
	write_from_user_input = 0
	write_from_query = 0
	#The whoe query
	read_to_read_query = 0
	read_to_write_query = 0
	read_to_view = 0
	read_to_branch = 0
	$node_list.each do |n|
		if n.isQuery?
			total_query_num += 1
			if n.getInstr.getCallHandler != nil
				@tbl_name = n.getInstr.getCallHandler.getTableName
					if n.getInstr.getCallHandler.caller != nil
						@tbl_name = n.getInstr.getCallHandler.caller.getName
					end
				graph_write($graph_file, "#{n.getInstr.getCallHandler.getObjName}.#{n.getInstr.getFuncname} <#{@tbl_name},#{n.getInstr.getCallHandler.getQueryType}>")
			else
				graph_write($graph_file, "#{n.getInstr.getCaller}.#{n.getInstr.getFuncname}")
			end
			if n.getInClosure
				query_in_closure += 1
				if n.getInView
					graph_write($graph_file, " (v)")
					query_in_view += 1
				end
				if n.getInView and n.getClosureStack.length == 1
				else #n.getInView == false or n.getClosureStack.length > 1
					graph_write($graph_file, " (c)")
				end
			end
			if ["SELECT","GROUP","JOIN"].include?n.getInstr.getCallHandler.getQueryType
				query_read += 1
				single_tbl_to_read_query = 0
				single_tbl_to_write_query = 0
				single_tbl_to_view = 0
				single_tbl_to_branch = 0

				#puts "READ query instr #{n.getIndex}:#{n.getInstr.toString} forward flow:"
				v_node = find_nearest_var(n)
				self_v_name = nil
				if v_node != nil
					if v_node.getInstr.getDefv != nil
						self_v_name = v_node.getInstr.getDefv
					else #AttrAssign_instr
						self_v_name = v_node.getInstr.getFuncname
					end
				end
				if self_v_name != nil
					#puts "* #{n.getIndex}:#{n.getInstr.toString} result into #{self_v_name}"
					cnt_materialized_query += 1
					#graph_write($graph_file, " into_#{self_v_name}")
				end
				traceforward_data_dep(n).each do |n1|
					#if n1.isField?
					#	var_name = n1.getInstr.getCallHandler.getObjName
					#	field_name = n1.getInstr.getCallHandler.getFuncName
					#	if (self_v_name == nil or self_v_name != var_name) and n1.getInstr.instance_of?AttrAssign_instr
					#			read_assign_to_other += 1
					#			single_tbl_assign_to_other += 1
					#			#puts "\t(read_assign_to_other)"
					#	end
					#elsif n1.getInstr.instance_of?AttrAssign_instr and n1.getInstr.getCaller.include?("self")
					#	read_assign_to_self += 1
					#	single_tbl_assign_to_self += 1
					#	#puts "\t(read_assign_to_self)"
					if n1.getInView
						#puts " * (To view)"
						single_tbl_to_view += 1
						read_to_view += 1
					elsif n1.isQuery?
						if ["DELETE","UPDATE","INSERT"].include?n1.getInstr.getCallHandler.getQueryType
								read_to_write_query += 1
								single_tbl_to_write_query += 1
								#puts " * (To write query)"
						else
								read_to_read_query += 1
								single_tbl_to_read_query += 1
								#puts " * (To read query)"
						end
					elsif n1.isBranch?
						read_to_branch += 1
						single_tbl_to_branch += 1
						#puts " * (To branch)"
					elsif n1.getDataflowEdges.length == 0
						#puts " * (To unknown sink)"
					end
					#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				end
				if n.getInstr.getCallHandler.caller != nil
					graph_write($graph_file, "\nTBLREADRECORD: #{n.getInstr.getCallHandler.caller.getName} [#{single_tbl_to_read_query},#{single_tbl_to_write_query},#{single_tbl_to_view},#{single_tbl_to_branch}]")
				end
			#elsif ["DELETE","UPDATE","INSERT"].include?n.getInstr.getCallHandler.getQueryType
			end
			if n.isQuery?
				query_write += 1
				#puts "READ / DELETE/UPDATE/INSERT instr #{n.getIndex}:#{n.getInstr.toString} backflow:"
				single_tbl_from_query = 0
				single_tbl_from_user = 0
				single_tbl_from_const = 0
				single_tbl_total = 0
				assigned_fields = Hash.new
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						#puts " x (From user input)"
						write_from_user_input += 1
						write_source_total += 1
						single_tbl_from_user += 1
						single_tbl_total += 1
					else
						if n1.isQuery? 
							if n1.isReadQuery?
								write_from_query += 1
								write_source_total += 1
								single_tbl_total += 1
								single_tbl_from_query += 1
								#puts " x (From query)"
							else
								#puts " (#{n.getInstr.toString}) depend on (#{n1.getInstr.toString})"
							end
						elsif n1.getInstr.instance_of?AttrAssign_instr
							call = n1.getInstr.getCallHandler
							assigned_fields[n1.getInstr.getFuncname] = true
							#puts "\t(Attr_assign)"
							#if call!=nil
							#	graph_write($graph_file, " --assign #{call.getObjName}.#{call.getFuncName} type=#{call.caller.getName}")
							#end
						elsif n1.getBackwardEdges.length == 0
							if n1.getInstr.instance_of?Copy_instr
								#puts " x (From copy const)"
								single_tbl_from_const += 1
								write_from_const += 1
							else
								#puts " x (Some source)"
							end
							write_source_total += 1
							single_tbl_total += 1
						end
						#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
					end
				end
				if n.getInstr.getCallHandler.caller != nil
					graph_write($graph_file, "\nTBLWRITERECORD: #{n.getInstr.getCallHandler.caller.getName} [#{single_tbl_from_query},#{single_tbl_from_user},#{single_tbl_from_const}] Fields: [");
					assigned_fields.each do |k,v|
						graph_write($graph_file, "#{k},")
					end
					graph_write($graph_file, "]")
				end
			end
			graph_write($graph_file, "\n")
	
		elsif n.isField?
			graph_write($graph_file, "+FIELD+ #{n.getInstr.getCallHandler.getObjName} #{n.getInstr.getCallHandler.caller.getName}.#{n.getInstr.getCallHandler.getField.field_name} (#{n.getInstr.getCallHandler.getField.type})\n")
			#test call handler same CFG: n.getInstr.getMethodDefCFG
			#puts "Field: #{n.getInstr.getCallHandler.getObjName} . #{n.getInstr.getCallHandler.getFuncName}"
		elsif n.isBranch?
			total_branch += 1
		 	q = traceback_data_dep(n, true)
			if q != nil
				branch_dependon_query += 1
				#puts "Branch depend on query:  #{q.getInstr.getCallHandler.getObjName} . #{q.getInstr.getCallHandler.getFuncName}"
			end
		end
	end
	graph_write($graph_file, "\n")
	graph_write($graph_file, "STATS query in total: #{total_query_num}\n")
	graph_write($graph_file, "STATS query in view: #{query_in_view}\n")
	graph_write($graph_file, "STATS query in closure: #{query_in_closure}\n")

	graph_write($graph_file, "STATS branch depend on query result: #{branch_dependon_query}\n")
	graph_write($graph_file, "STATS branch total: #{total_branch}\n")

	graph_write($graph_file, "STATS read queries: #{query_read}\n")
	graph_write($graph_file, "STATS read to read query: #{read_to_read_query}\n")
	graph_write($graph_file, "STATS read to write query: #{read_to_write_query}\n")
	graph_write($graph_file, "STATS read to view: #{read_to_view}\n")
	graph_write($graph_file, "STATS read to branch: #{read_to_branch}\n")

	graph_write($graph_file, "STATS materialized query: #{cnt_materialized_query}\n")

	graph_write($graph_file, "STATS write queries: #{query_write}\n")
	graph_write($graph_file, "STATS write from user input: #{write_from_user_input}\n")
	graph_write($graph_file, "STATS write from other queries: #{write_from_query}\n")
	graph_write($graph_file, "STATS write from const: #{write_from_const}\n")
	#if $query_depends_on.length > 0	
	#	graph_write($graph_file, "query backward dependencies: #{($query_depends_on.inject{|sum,x| sum + x })/($query_depends_on.length)}\n")
	#end
	#
	#if $query_determines.length > 0
	#	graph_write($graph_file, "query forward dependencies: #{($query_determines.inject{|sum,x| sum + x })/$query_determines.length}\n")
	#end
	#
	#if $query_determines_cflow.length + $query_depends_on_cflow.length > 0
	#	graph_write($graph_file, "query controlflow_dep: #{($query_depends_on_cflow.inject{|sum,x| sum + x }+$query_determines_cflow.inject{|sum,x| sum + x })/($query_depends_on_cflow.length+$query_determines_cflow.length)}\n")
	#end
		
	$graph_file.close
	#number of query functions
	#number of tables  --- Hard to know. If Comment.where(story_id <= 1).first, second "story" table will not be detected
	#number of query functions within loop
	#number of queries in view

end

def compute_dataflow_forward(output_dir, start_class, start_function, start_node)	
	#graph_fname = "#{output_dir}/FORWARD_#{start_class}_#{start_function}_#{start_node.getSimplifiedLabel}#{start_node.getIndex}.log"

	#$graph_file = File.open(graph_fname, "w");
	
	graph_write($graph_file, "digraph #{remove_special_chars(start_class)}_#{start_function}_forward_#{start_node.object_id} {\n")

	#dname = "digraph #{start_class}_#{start_function}_forward_#{start_node.getLabel} {\n"
	#graph_write($graph_file, "#{remove_special_chars(dname)}")

	$computed_node = Array.new	
	compute_forward_singlenode(start_node)

	$computed_node.each do |c|
		if c == start_node
      if c.getInView
              color = "blue"
      else
              color = "crimson"
      end	
			graph_write($graph_file, "\tn#{c.getIndex} [label=<<i>#{c.getLabel}</i>> color=#{color} shape=doubleoctagon]; \n")	
		else
			$cnt_determines += 1
			graph_write($graph_file, "\tn#{c.getIndex} [");
			if c.getInstr.is_a?Call_instr 
				graph_write($graph_file, "label = <<i>#{c.getLabel}</i>> ")
			end
			if c.getInstr.getToUserOutput
				graph_write($graph_file, "color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.is_a?Call_instr and c.getInstr.isQuery
				graph_write($graph_file, "color=#{$QNODECOLOR} ")
			end
			graph_write($graph_file, "]\n")
		end
	end
	
	graph_write($graph_file, "}\n\n")
	#$graph_file.close
end


def compute_dataflow_backward(output_dir, start_class, start_function, start_node)	
	#graph_fname = "#{output_dir}/BACKWARD_#{start_class}_#{start_function}_#{start_node.getSimplifiedLabel}#{start_node.getIndex}.log"

	#$graph_file = File.open(graph_fname, "w");
	
	graph_write($graph_file, "digraph #{remove_special_chars(start_class)}_#{start_function}_backward_#{start_node.object_id} {\n")
	#dname = "digraph #{start_class}_#{start_function}_backward_#{start_node.getLabel} {\n"
	#graph_write($graph_file, "#{remove_special_chars(dname)}")

	$computed_node = Array.new	
	compute_backward_singlenode(start_node)

	$computed_node.each do |c|
		if c == start_node
			if c.getInView
              color = "blue"
      else
              color = "crimson"
      end	
			graph_write($graph_file, "\tn#{c.getIndex} [label=<<i>#{c.getLabel}</i>> color=#{color} shape=doubleoctagon]; \n")
		else
			$cnt_depends_on += 1
			graph_write($graph_file, "\tn#{c.getIndex} [");
			if c.getInstr.is_a?Call_instr 
				graph_write($graph_file, "label = <<i>#{c.getLabel}</i>> ")
			end
			if c.getInstr.getFromUserInput
				graph_write($graph_file, "color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.is_a?Call_instr and c.getInstr.isQuery
				graph_write($graph_file, "color=#{$QNODECOLOR} ")
			end
			graph_write($graph_file, "]\n")
		end
	end
	
	graph_write($graph_file, "}\n\n")
	#$graph_file.close
end

def compute_forward_singlenode(node)
	if $computed_node.include?(node)
		return
	end
	$computed_node.push(node)
	node.getDataflowEdges.each do |e|
		graph_write($graph_file, "\tn#{e.getFromNode.getIndex} -> n#{e.getToNode.getIndex}")
		if e.getIsBranching
			$cnt_determins_cflow += 1
			graph_write($graph_file, " [color=#{$FLOWEDGE_COLOR}];")
		end
		graph_write($graph_file, "\n");
		compute_forward_singlenode(e.getToNode)
	end
end

def compute_backward_singlenode(node)
	
	if $computed_node.include?(node)
		return
	end
	$computed_node.push(node)
	node.getBackwardEdges.each do |e|
		if e.getFromNode != nil and e.getToNode != nil
			graph_write($graph_file, "\tn#{e.getFromNode.getIndex} -> n#{e.getToNode.getIndex}")
			if e.getIsBranching
				$cnt_depends_on_cflow += 1
				graph_write($graph_file, " [color=#{$FLOWEDGE_COLOR}];")
			end
			graph_write($graph_file, "\n");
			compute_backward_singlenode(e.getFromNode)
		end
	end
end
