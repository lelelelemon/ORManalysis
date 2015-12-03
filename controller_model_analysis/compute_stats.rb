$QNODECOLOR = "coral1"
$USERINOUTCOLOR = "cyan3"

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
						$graph_file.write("n#{n1.getIndex} -> n#{n2.getIndex}\n")
					end
				end
			end
		end
	end		
end

def print_query_graph(output_dir, start_class, start_function)

	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_Qgraph.log"
	$graph_file = File.open(graph_fname, "w");

	$graph_file.write("digraph #{start_class}_#{start_function} {\n")
	print_graph2(start_class, start_function)
	$graph_file.write("}");

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
				$graph_file.write("\tn#{n.getIndex} [label = \"#{n.getLabel}\"]; \n")
			else
				$graph_file.write("\tn#{n.getIndex} [label = \"#{n.getLabel}\" style=filled color=orange]; \n")
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

def compute_dataflow_stat(output_dir, start_class, start_function)


	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_stats.txt"
	$graph_file = File.open(graph_fname, "w");
	
	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end

	total_query_num = 0
	query_in_closure = 0
	query_in_view = 0
	$node_list.each do |n|
		n.setLabel
		if n.isQuery?
			total_query_num += 1
			if n.getInstr.getCallHandler != nil
				$graph_file.write("#{n.getInstr.getCallHandler.getObjName}.#{n.getInstr.getFuncname}")
			else
				$graph_file.write("#{n.getInstr.getCaller}.#{n.getInstr.getFuncname}")
			end
			if n.getInClosure
				query_in_closure += 1
				if n.getToUserOutput
					$graph_file.write(" (v)\n")
					query_in_view += 1
				end
				$graph_file.write(" (c)\n")
			end
			$graph_file.write("\n")
		end
	end
	$graph_file.close
	#number of query functions
	#number of tables  --- Hard to know. If Comment.where(story_id <= 1).first, second "story" table will not be detected
	#number of query functions within loop
	#number of queries in view

	$node_list.each do |n|
		if n.isQuery?
			compute_dataflow_forward(output_dir, start_class, start_function, n)	
			compute_dataflow_backward(output_dir, start_class, start_function, n)
		end
	end
end

def compute_dataflow_forward(output_dir, start_class, start_function, start_node)	
	graph_fname = "#{output_dir}/FORWARD_#{start_class}_#{start_function}_#{start_node.getLabel}#{start_node.getIndex}.log"

	$graph_file = File.open(graph_fname, "w");
	
	$graph_file.write("digraph #{start_class}_#{start_function} {\n")

	$computed_node = Array.new	
	compute_forward_singlenode(start_node)

	$computed_node.each do |c|
		if c == start_node	
			$graph_file.write("\tn#{c.getIndex} [label = \"#{c.getLabel}\" color=crimson, shape=doubleoctagon]; \n")	
		elsif c.getInstr.instance_of?Call_instr
			$graph_file.write("\tn#{c.getIndex} [label = \"#{c.getLabel}\" color=#{$QNODECOLOR}]; \n")	
		elsif c.getInstr.getToUserOutput	
			$graph_file.write("\tn#{c.getIndex} [color=#{$USERINOUTCOLOR}]; \n")	
		end
	end
	
	$graph_file.write("}")
	$graph_file.close
end


def compute_dataflow_backward(output_dir, start_class, start_function, start_node)	
	graph_fname = "#{output_dir}/BACKWARD_#{start_class}_#{start_function}_#{start_node.getLabel}#{start_node.getIndex}.log"

	$graph_file = File.open(graph_fname, "w");
	
	$graph_file.write("digraph #{start_class}_#{start_function} {\n")

	$computed_node = Array.new	
	compute_backward_singlenode(start_node)

	$computed_node.each do |c|
		if c == start_node	
			$graph_file.write("\tn#{c.getIndex} [label = \"#{c.getLabel}\" color=crimson, shape=doubleoctagon]; \n")
		elsif c.getInstr.instance_of?Call_instr
			$graph_file.write("\tn#{c.getIndex} [label = \"#{c.getLabel}\" color=#{$QNODECOLOR}]; \n")	
		elsif c.getInstr.getFromUserInput	
			$graph_file.write("\tn#{c.getIndex} [color=#{$USERINOUTCOLOR}]; \n")	
		end
	end
	
	$graph_file.write("}")
	$graph_file.close
end

def compute_forward_singlenode(node)
	if $computed_node.include?(node)
		return
	end
	$computed_node.push(node)
	node.getDataflowEdges.each do |e|
		$graph_file.write("\tn#{e.getFromNode.getIndex} -> n#{e.getToNode.getIndex}")
		if e.getIsBranching
			$graph_file.write(" [color=#{$FLOWEDGE_COLOR}];")
		end
		$graph_file.write("\n");
		compute_forward_singlenode(e.getToNode)
	end
end

def compute_backward_singlenode(node)
	
	if $computed_node.include?(node)
		return
	end
	$computed_node.push(node)
	node.getBackwardEdges.each do |e|
		$graph_file.write("\tn#{e.getFromNode.getIndex} -> n#{e.getToNode.getIndex}")
		if e.getIsBranching
			$graph_file.write(" [color=#{$FLOWEDGE_COLOR}];")
		end
		$graph_file.write("\n");
		compute_backward_singlenode(e.getFromNode)
	end
end
