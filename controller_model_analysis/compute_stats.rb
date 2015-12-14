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
$cnt_depends_on = 0
$cnt_determines = 0
$cnt_depends_on_cflow = 0
$cnt_determines_cflow = 0

def compute_dataflow_stat(output_dir, start_class, start_function)

	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end
	
	$node_list.each do |n|
		n.setLabel
		puts "#{n.getIndex}: #{n.getInstr.toString}"
	end
	
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
	$node_list.each do |n|
		if n.isQuery?
			total_query_num += 1
			if n.getInstr.getCallHandler != nil
				$graph_file.write("#{n.getInstr.getCallHandler.getObjName}.#{n.getInstr.getFuncname}")
			else
				$graph_file.write("#{n.getInstr.getCaller}.#{n.getInstr.getFuncname}")
			end
			if n.getInClosure
				query_in_closure += 1
				if n.getInstr.getToUserOutput
					$graph_file.write(" (v)\n")
					query_in_view += 1
				end
				$graph_file.write(" (c)\n")
			end
			$graph_file.write("\n")
		end
	end
	if $query_depends_on.length > 0	
		$graph_file.write("query backward dependencies: #{($query_depends_on.inject{|sum,x| sum + x })/($query_depends_on.length)}\n")
	end
	
	if $query_determines.length > 0
		$graph_file.write("query forward dependencies: #{($query_determines.inject{|sum,x| sum + x })/$query_determines.length}\n")
	end
	
	if $query_determines_cflow.length + $query_depends_on_cflow.length > 0
		$graph_file.write("query controlflow_dep: #{($query_depends_on_cflow.inject{|sum,x| sum + x }+$query_determines_cflow.inject{|sum,x| sum + x })/($query_depends_on_cflow.length+$query_determines_cflow.length)}\n")
	end
		
	$graph_file.close
	#number of query functions
	#number of tables  --- Hard to know. If Comment.where(story_id <= 1).first, second "story" table will not be detected
	#number of query functions within loop
	#number of queries in view

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
		else
			$cnt_determines += 1
			$graph_file.write("\tn#{c.getIndex} [");
			if c.getInstr.instance_of?Call_instr 
				$graph_file.write("label = \"#{c.getLabel}\" ")
			end
			if c.getInstr.getToUserOutput
				$graph_file.write("color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.instance_of?Call_instr and c.getInstr.isQuery
				$graph_file.write("color=#{$QNODECOLOR} ")
			end
			$graph_file.write("]\n")
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
		else
			$cnt_depends_on += 1
			$graph_file.write("\tn#{c.getIndex} [");
			if c.getInstr.instance_of?Call_instr 
				$graph_file.write("label = \"#{c.getLabel}\" ")
			end
			if c.getInstr.getFromUserInput
				$graph_file.write("color=#{$USERINOUTCOLOR} ")
			elsif c.getInstr.instance_of?Call_instr and c.getInstr.isQuery
				$graph_file.write("color=#{$QNODECOLOR} ")
			end
			$graph_file.write("]\n")
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
			$cnt_determins_cflow += 1
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
		if e.getFromNode != nil and e.getToNode != nil
			$graph_file.write("\tn#{e.getFromNode.getIndex} -> n#{e.getToNode.getIndex}")
			if e.getIsBranching
				$cnt_depends_on_cflow += 1
				$graph_file.write(" [color=#{$FLOWEDGE_COLOR}];")
			end
			$graph_file.write("\n");
			compute_backward_singlenode(e.getFromNode)
		end
	end
end
