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
				if e.getFromNode.isQuery?
					@dep_array.push(e.getFromNode)
					if stop_at_query
						return e.getFromNode
					end	
				else
					#test is both nodes are in the same basic block, prevent from tracing too far
					#if e.getFromNode.getInstr.getBB == node.getInstr.getBB
					if @node_list.include?(e.getFromNode) == false and @dep_array.include?(e.getFromNode) == false
						@dep_array.push(e.getFromNode)
						@node_list.push(e.getFromNode)
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
				return e.getToNode
			elsif e.getToNode.isBranch?
				return e.getToNode
			else
				if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
					@node_list.push(e.getToNode)
				end
			end
		end
	end
	return nil
end

def traceforward_data_dep(cur_node, query_node)
	@traversed = Array.new
	@node_list = Array.new
	@node_list.push(cur_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		@traversed.push(node)
		node.getDataflowEdges.each do |e|
			#e.getToNode will never be nil
			if e.getToNode.isField?
				#check caller name matches
				var_name = e.getToNode.getInstr.getCallHandler.getObjName
				f_name = e.getToNode.getInstr.getCallHandler.getFuncName
				puts "\t* Field #{var_name} . #{f_name} is being used"
				#cur_node must define sth
				#if cur_node.getDefv == var_name
					#puts "#{var_name} . #{e.getToNode.getInstr.getCallHandler.getFuncName} from [query] #{query_node.getInstr.toString} is used"
				#end
			elsif e.getToNode.isQuery?
			else
				if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
					@node_list.push(e.getToNode)
				end	
			end
		end
	end
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
				puts "\t\t <- params"
			end
		end
		#puts "#{n.getIndex}: #{n.getInstr.toString}"
	end

	graph_fname = "#{output_dir}/backward_forward.log"
	$graph_file = File.open(graph_fname, "w")

	
	$node_list.each do |n|
		if n.isQuery?
			$cnt_depends_on = 0
			$cnt_determines = 0
			$cnt_depends_on_cflow = 0
			$cnt_determines_cflow = 0
			compute_dataflow_forward(output_dir, start_class, start_function, n)
			compute_dataflow_backward(output_dir, start_class, start_function, n)
			$query_depends_on.push($cnt_depends_on)
			$query_determines.push($cnt_determines)
			$query_depends_on_cflow.push($cnt_depends_on_cflow)
			$query_determines_cflow.push($cnt_determines_cflow)
			#puts "#{n.getInstr.toString}"
			#puts "cnt_depends_on = #{$cnt_depends_on}"
			#puts "cnt_determins = #{$cnt_determines}"
		end
	end


	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_stats.txt"
	$graph_file = File.open(graph_fname, "w");

	total_query_num = 0
	query_in_closure = 0
	query_in_view = 0
	query_read = 0
	query_write = 0
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
				puts "READ query instr #{n.getIndex}:#{n.getInstr.toString} forward flow:"
				traceforward_data_dep(n,n).each do |n1|
					puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				end	
			elsif ["DELETE","UPDATE","INSERT"].include?n.getInstr.getCallHandler.getQueryType
				query_write += 1
				#puts "DELETE/UPDATE/INSERT instr #{n.getIndex}:#{n.getInstr.toString} backflow:"
				#traceback_data_dep(n).each do |n1|
				#	if n1.instance_of?Edge
				#		puts "\t--\tFrom user input"
				#	else
				#		puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				#	end
				#end
			end
			graph_write($graph_file, "\n")
	
		elsif n.isField?
			graph_write($graph_file, "+FIELD+ #{n.getInstr.getCallHandler.caller.getName}.#{n.getInstr.getCallHandler.getField.field_name} (#{n.getInstr.getCallHandler.getField.type})\n")
			#test call handler same CFG: n.getInstr.getMethodDefCFG
			#puts "Field: #{n.getInstr.getCallHandler.getObjName} . #{n.getInstr.getCallHandler.getFuncName}"
		elsif n.isBranch?
		 	q = traceback_data_dep(n, true)
			if q != nil
				#puts "Branch depend on query:  #{q.getInstr.getCallHandler.getObjName} . #{q.getInstr.getCallHandler.getFuncName}"
			end
		end
	end
	graph_write($graph_file, "\n")
	graph_write($graph_file, "query in total: #{total_query_num}\n")
	graph_write($graph_file, "query in view: #{query_in_view}\n")
	graph_write($graph_file, "query in closure: #{query_in_closure}\n")
	graph_write($graph_file, "read queries: #{query_read}\n")
	graph_write($graph_file, "write queries: #{query_write}\n")
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
			if c.getInstr.instance_of?Call_instr 
				graph_write($graph_file, "label = <<i>#{c.getLabel}</i>> ")
			end
			if c.getInstr.getToUserOutput
				graph_write($graph_file, "color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.instance_of?Call_instr and c.getInstr.isQuery
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
			if c.getInstr.instance_of?Call_instr 
				graph_write($graph_file, "label = <<i>#{c.getLabel}</i>> ")
			end
			if c.getInstr.getFromUserInput
				graph_write($graph_file, "color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.instance_of?Call_instr and c.getInstr.isQuery
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
