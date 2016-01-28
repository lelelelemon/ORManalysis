class TEdge
	def initialize(dist, c)
		@node = c
		@dist = dist
	end
	attr_accessor :node, :dist
end

class TreeNode
  def initialize(node)
		@node = node
		@children = Array.new
		@dist = Array.new
		@tag = nil
	end
	attr_accessor :children, :node, :tag
	#c has type TreeNode
	def addChildren(c, dist)
		edge = TEdge.new(dist, c)
		@children.push(edge)
	end
	def hasChildren(c)
		@children.each do |c1|
			if c1.node == c 
				return true
			end
		end
		return false
	end
end

#This is a stack, tracking TNode on a specific path, preventing duplicate node on a single path
$path_tracker = Array.new
#The direction of parent->children is the reverse of the direction of dataflow edge
#Similar with func traceback_data_dep, but use depth-first search, not width-first search
def calculate_backward_path_tree(parent_Tnode, from_node, root_node)
 	cur_Tnode = TreeNode.new(from_node)
	parent_Tnode.addChildren(cur_Tnode)
	$path_tracker.push(cur_Tnode)
  from_node.getBackwardEdges.each do |e|
		if e.getFromNode != nil
			if $path_tracker.include?(e.getFromNode)
			else
				if root_node.getIndex > e.getFromNode.getIndex
					calculate_backward_path_tree(cur_Tnode, e.getFromNode, root_node)
				end
			end
		elsif e.getFromNode == nil
			#do nothing
		end
	end
	$path_tracker.pop
end

$sketch_node_list = Array.new
#Since the graph may contain backward edges, cannot build sketch use the tree algorithms
#Compute connection based on the number of hops, which might be very slow...
def build_sketch_graph
	@temp_hop_record = Hash.new
	@processed_list = Hash.new
	$node_list.each do |n|
		#Nodes in sketched graph: queries, user_inputs
		#if n.getInstr.getFromUserInput or (n.isQuery? and n.isWriteQuery?) or (n.getInstr.instance_of?AttrAssign_instr and n.getInstr.getFuncname.index('!') == nil)
		if n.getInstr.getFromUserInput or n.isQuery? or isTableAttrAssign(n) 
			n.Tnode = TreeNode.new(n)
			$sketch_node_list.push(n.Tnode)	
			@temp_hop_record[n] = Array.new
			@processed_list[n] = Array.new
			@temp_hop_record[n].push(n)
		end 
	end
	for i in 0...$node_list.length
		added_edge = false
		no_changes = true
		$node_list.each do |n|
			if n.Tnode != nil
				@temp_hop_record[n].push(nil)
				temp_node = @temp_hop_record[n].shift
				while temp_node != nil do
					no_changes = false
					temp_node.getDataflowEdges.each do |e|
						if e.getToNode.Tnode != nil and e.getToNode != n
							if n.Tnode.hasChildren(e.getToNode.Tnode) == false and (n.getIndex < e.getToNode.getIndex)
								n.Tnode.addChildren(e.getToNode.Tnode, i)
								#puts "\tAdd edge: #{n.getIndex}:#{n.getInstr.toString} -> #{e.getToNode.getIndex}:#{e.getToNode.getInstr.toString}"
								added_edge = true
							end
						else
							if e.getToNode != n 
								if @processed_list[n].include?e
								elsif e.getToNode.getIndex < e.getFromNode.getIndex #returnv
									e.getToNode.getDataflowEdges.each do |e1|
										if e1.getToNode.getIndex > temp_node.getIndex
											@temp_hop_record[n].push(e1.getToNode)
											@processed_list[n].push(e1)
										end 
									end
								else
									@temp_hop_record[n].push(e.getToNode)
									@processed_list[n].push(e)
								end
							end
						end
					end
					temp_node = @temp_hop_record[n].shift
				end
			end
		end
		if added_edge
			#puts "iteration #{i}  ||"
		end
		if no_changes
			break
		end
	end

	graph_write($graph_file, "digraph sketch {\n")
	$node_list.each do |n|
		if n.Tnode != nil
			if n.isQuery?
				color = "blue"
			elsif n.getInstr.instance_of?AttrAssign_instr
				color = "darkorange"
			else
				color = "crimson"
			end
			graph_write($graph_file, "\tn#{n.getIndex} [label=<<i>#{n.getIndex}__#{n.getInstr.toString2}</i>> color=#{color}]; \n")
			n.Tnode.children.each do |c|
				graph_write($graph_file, "\tn#{n.getIndex} -> n#{c.node.node.getIndex} [label=\"#{c.dist}\"]\n")
			end
		end
	end
	graph_write($graph_file, "}")
end

def isSource(node)
	if node.isReadQuery?
		return true
	elsif node.getBackwardEdges.length == 0
		return true
	else
		return false
	end
end

def isRecognizedSource(node)
	if node.getInstr.getFromUserInput
		return true
	elsif node.isReadQuery?
		return true
	elsif node.getInstr.instance_of?Copy_instr
		return true
	else
		return false
	end
end

def isSink(node)
	if node.isWriteQuery?
		return true
	elsif node.getDataflowEdges.length == 0
		return true
	else
		return false
	end
end

def isRecognizedSink(node)
	if node.isQuery?
		return true
	elsif node.getInstr.instance_of?Branch_instr
		return true
	elsif node.getInView
		return true
	end
end

#helper func
def compute_source_sink_for_all_nodes
	#source
	@processed_list = Array.new
	while @processed_list.length < $node_list.length
		$node_list.each do |n|
			if @processed_list.include?n
			else
				all_processed = true
				n.getBackwardEdges.each do |e|
					if e.getFromNode != nil
						if @processed_list.include?e.getFromNode == false and e.getFromNode.getIndex < n.getndex
							all_processed = false
						else
							e.getFromNode.source_list.each do |i|
								if n.source_list.include?i
								else
									n.source_list.push(i)
								end
							end
							if isSource(e.getFromNode)
								n.source_list.push(e.getFromNode)
							end
						end
					end
				end
				if all_processed
					@processed_list.push(n)
				end
			end
		end
	end

	#sink
	@processed_list = Array.new
	while @processed_list.length < $node_list.length
		$node_list.reverse.each do |n|
			if @processed_list.include?n
			else
				all_processed = true
				n.getDataflowEdges.each do |e|
					if e.getToNode != nil
						if @processed_list.include?e.getToNode == false and e.getToNode.getIndex > n.getIndex
							all_processed = false
						elsif @processed_list.include?e.getToNode == false
							#e.getToNode.getIndex < n.getIndex
							if e.getVname == "returnv"
								e.getToNode.getDataflowEdgs.each do |e1|
									if @processed_list.include?e1.getToNode
										e1.getToNode.sink_list.each do |i|
											if n.sink_list.include?i
											else
												n.sink_list.push(i)
											end
										end
									end
									if isSink(e1.getFromNode)
										n.sink_list.push(e1.getToNode)
									end
								end
							end
						end
						if @processed_list.include?e.getToNode
							e.getToNode.sink_list.each do |i|
								if n.sink_list.include?i
								else
									n.sink_list.push(i)
								end
							end
							if isSink(e.getToNode)
								n.sink_list.push(e.getToNode)
							end
						end
					end
				end
				if all_processed
					#puts "Handle node #{n.getIndex}:#{n.getInstr.toString}, sink_list.length = #{n.sink_list.length}"
					@processed_list.push(n)
				end
			end
		end
	end

	#$node_list.each do |n|
	#	puts "#{n.getIndex}:#{n.getInstr.toString}"
	#	n.source_list.each do |s|
	#		puts "\t source: #{s.getIndex}:#{s.getInstr.toString}"
	#	end
	#end
end

#helper func
def controller_path_reachable(start_node, end_node)
	#standard breadth first search
	#@pre_node = Hash.new
	@processed_list = Array.new
	@processed_list.push(start_node)
	@temp_node_list = Array.new
	@temp_node_list.push(start_node)
	reach_end = false
	temp_node = start_node
	while (!reach_end and temp_node.getIndex > end_node.getIndex)
		temp_node = @temp_node_list.shift
		if temp_node == end_node
			reach_end = true
			break
		else
			temp_node.getControlflowEdges.each do |e|
				if @processed_list.include?(e.getToNode)
				else
					@processed_list.push(e.getToNode)
					#@pre_node[e.getToNode] = temp_node
					@temp_node_list.push(e.getToNode)
				end
			end
		end
	end
	return reach_end
#	@return_list = Array.new
#	temp_node = end_node
#	while temp_node != nil and temp_node != start_node
#		@return_list.insert(0, temp_node)
#		temp_node = @pre_node[temp_node]
#	end
#	return @return_list
end

#helper func
def find_path_between_two_nodes(start_node, end_node)
	#standard breadth first search
	@pre_node = Hash.new
	@processed_list = Array.new
	@processed_list.push(start_node)
	@temp_node_list = Array.new
	@temp_node_list.push(start_node)
	reach_end = false
	while !reach_end
		temp_node = @temp_node_list.shift
		if temp_node == end_node
			reach_end = true
			break
		else
			temp_node.getDataflowEdges.each do |e|
				if @processed_list.include?(e.getToNode)
				else
					@processed_list.push(e.getToNode)
					@pre_node[e.getToNode] = temp_node
					@temp_node_list.push(e.getToNode)
				end
			end
		end
	end
	@return_list = Array.new
	temp_node = end_node
	while temp_node != nil and temp_node != start_node
		@return_list.insert(0, temp_node)
		temp_node = @pre_node[temp_node]
	end
	return @return_list
end

#Find all the def-use chains of sketch nodes, and compute if combining them, the "overhead"
$processed_node_stack = Array.new
def compute_single_chain_node(cur_node)
	#recursive function, depth first search
	if cur_node.Tnode.children.length == 0 and $processed_node_stack.length > 0
		$processed_node_stack.push(cur_node)
		chain_length = $processed_node_stack.length
		#if combining all the queries on this chain into a single big node...
		out_sink_nodes = 0
		out_nodes = 0
		in_source_nodes = 0
		in_nodes = 0
		out_sink_list = Array.new
		in_source_list = Array.new
		#find all the nodes on the chain
		@chain_node_list = Array.new
		@chain_node_list.push($processed_node_stack[0])
		temp_r = Hash.new
		for i in 1...$processed_node_stack.length
			#puts "Find path between #{$processed_node_stack[i-1].getIndex} and #{$processed_node_stack[i].getIndex}"
			temp_processed_list = find_path_between_two_nodes($processed_node_stack[i-1], $processed_node_stack[i])
			str = "#{$processed_node_stack[i-1].getIndex} to #{ $processed_node_stack[i].getIndex}"
			temp_r[str] = temp_processed_list.length
			#puts "\t list length = #{temp_processed_list.length}"
			@chain_node_list.concat(temp_processed_list)
		end
		@chain_node_list.each do |n|
			n.getDataflowEdges.each do |e|
				if @chain_node_list.include?e.getToNode
					out_nodes += 1
				end
			end
			n.sink_list.each do |s|
				if out_sink_list.include?s
				else
					out_sink_list.push(s)
				end
			end
		end
		@chain_node_list.each do |n|
			n.getBackwardEdges.each do |e|
				if e.getFromNode != nil and @chain_node_list.include?e.getFromNode
					in_nodes += 1
				end
			end
			n.source_list.each do |s|
				if in_source_list.include?s
				else
					in_source_list.push(s)
				end
			end
		end
		out_sink_list.each do |s|
			if isRecognizedSink(s)
				out_sink_nodes += 1
			end 
		end
		in_source_list.each do |s|
			if isRecognizedSource(s)
				if s.getInstr.instance_of?Copy_instr
				else
					in_source_nodes += 1
				end
			end
		end

		#puts "\t# # # reach end: from #{$processed_node_stack[0].getIndex} to #{cur_node.getIndex}  chain_length = #{chain_length}, total_length = #{@chain_node_list.length}"
		#temp_r.each do |t,v|
		#	puts "\t\t$ From #{t}: #{v}"
		#end

		$graph_file.write("chain: #{chain_length} #{out_nodes} #{in_nodes} #{out_sink_nodes} #{in_source_nodes}\n")

		$processed_node_stack.pop
	elsif cur_node.Tnode.children.length == 0
		#Only one node on the chain
		$graph_file.write("chain: 1 0 0 0 0\n")
	else
		$processed_node_stack.push(cur_node)
		cur_node.Tnode.children.each do |c|
			if $processed_node_stack.include?(c.node.node)
			else
				compute_single_chain_node(c.node.node)
			end
		end
		$processed_node_stack.pop
	end
end

#Basically compute the importance of a user input: how many query nodes it can reach
def compute_reachability(n)
	@processed_list = Array.new
	@reaches = Array.new
	@queue = Array.new
	@queue.push(n)
	while @queue.length > 0
		temp_node = @queue.shift
		@processed_list.push(temp_node)
		temp_node.Tnode.children.each do |c|
			if @processed_list.include?c.node.node
			else
				@queue.push(c.node.node)
				@reaches.push(c.node.node)
			end
		end
	end
	return @reaches.length
end

def compute_chain_stats
	$sketch_node_list.each do |n|
		#puts "#{n.node.getIndex}:#{n.node.getInstr.toString}"
	end

	$sketch_node_list.each do |n|
		is_root = true
		$sketch_node_list.each do |n1|
			if n1.hasChildren(n)
				is_root = false
			end
		end
		if is_root
			#puts "Root node: #{n.node.getIndex}:#{n.node.getInstr.toString}"
			compute_single_chain_node(n.node)
			
			if n.node.getInstr.getFromUserInput
				reaches = compute_reachability(n.node)
				$graph_file.write("Input: #{reaches}\n")
				if reaches == 0
					#puts "ZERO reach #{n.node.getIndex}:#{n.node.getInstr.toString}"
				end
				#puts "Input #{n.node.getIndex} reaches #{reaches}"
			end
		end 
	end

	#OK, here we compute fields being assigned but not part of schema
	#should be in compute_stats.rb...
	@notstored_fields = Hash.new
	@notstored_f_source = Hash.new
	@stored_fields = Hash.new
	@stored_f_source = Hash.new
	$node_list.each do |n|
		if n.isField? or n.getInstr.instance_of?AttrAssign_instr
			var_name = n.getInstr.getCallHandler.getObjName
			field_name = n.getInstr.getCallHandler.getFuncName
			#field_instance = n.getInstr.getCallHandler.getField
			tbl_name = n.getInstr.getCallHandler.caller.getName
			p_s = "#{var_name} (#{tbl_name}) . #{field_name}"
			s = "#{tbl_name}.#{field_name}"
			if isTableField(tbl_name, field_name)
				p_s = p_s + " -> field"
				if n.getInstr.instance_of?AttrAssign_instr
					if @stored_fields.has_key?(s)
						@stored_fields[s] += 1
					else
						@stored_fields[s] = 1
						@stored_f_source[s] = 0
						n.source_list.each do |sn|
							r_lst = find_path_between_two_nodes(sn, n)
							@stored_f_source[s] += r_lst.length
						end
					end
				end
			elsif isActiveRecord(tbl_name)
				p_s = p_s + " -> non field"
				if @notstored_fields.has_key?(s)
					@notstored_fields[s] += 1
				else
					@notstored_fields[s] = 1
					@notstored_f_source[s] = 0
					n.source_list.each do |sn|
						r_lst = find_path_between_two_nodes(sn, n)
						@notstored_f_source[s] += r_lst.length
					end
				end
				#puts "#{p_s}"	
			end
		end
	end	
	@notstored_fields.each do |f,v|
		$graph_file.write("Nonfield: #{f} #{v} #{@notstored_f_source[f]}\n")
	end
	@stored_fields.each do |f,v|
		$graph_file.write("FieldAssign: #{f} #{v} #{@stored_f_source[f]}\n")
	end
end
#pattern 1: root1 is on the path of root2, which means node in root1 defines sth that node in root2 uses
#pattern 2: root1 and root2 merge at some point: share common node.
#def compare_backward_path_trees(root1, root2)
		
#end
