load 'read_dataflow.rb'

class INode
	def initialize(instr)
		if instr != nil
			instr.setINode(self)
		end
 		@instr = instr
		@isQuery = false
		@children = Array.new
		@index = $ins_cnt
		@label = ""
		@in_closure = false
		@closure_stack = Array.new
		@dataflow_edges = Array.new
		@backward_dataflow_edges = Array.new
		if $closure_stack.length > 0
			@in_closure = true
			$closure_stack.each do |cl|
				@closure_stack.push(cl)
			end
		end
	end
	def addDataflowEdge(edge)
		@dataflow_edges.push(edge)
		edge.getToNode.addBackwardEdge(edge)
	end
	def addBackwardEdge(edge)
		@backward_dataflow_edges.push(edge)
	end
	def getBackwardEdges
		@backward_dataflow_edges
	end
	def getDataflowEdges
		@dataflow_edges
	end
	def getInClosure
		@in_closure
	end
	def isQuery?
		if @instr != nil and @instr.instance_of?Call_instr
			return @instr.getCaller.isQuery
		end
		return false
	end
	def setLabel
		if isQuery?
			if @instr.getResolvedCaller.length > 0
				@label = "#{@instr.getResolvedCaller}.#{@instr.getFuncname}"
			else
				@label = "#{@instr.getCallHandler.getObjName}.#{@instr.getFuncname}"
			end
		elsif @instr.instance_of?Call_instr
			if @instr.getCallHandler != nil
				@label = "#{@instr.getCallHandler.getObjName}.#{@instr.getFuncname}"
			else
				@label = "#{@instr.getFuncname}"
			end
		end
	end
	def getLabel
		@label
	end
	def getInstr
		@instr
	end
	def getIndex
		@index
	end
	def addChild(c)
		@children.push(c)
	end
	def getChildren
		@children
	end
	def setIsQuery
		@isQuery = true
	end
	def isQuery?
		@isQuery
	end	
end


$root = nil
$cfg
$ins_cnt = 0
#store all instruction node
$node_list = Array.new
#the very source of dataflow, all nodes using user input connect to this node
$dataflow_source = INode.new(nil)

#format: from_inode_index*to_inode_index
$dataflow_edges = Hash.new
class Edge
	def initialize(fromn, ton, vname, isBranching=false)
		@from_node = fromn
		@to_node = ton
		@vname = vname
		@is_branching = isBranching
	end
	def getIsBranching
		@is_branching
	end
	def getFromNode
		@from_node
	end
	def getToNode
		@to_node
	end
	def getVname
		@vname
	end
end

def add_dataflow_edge(node)
	to_ins = node.getInstr
	if to_ins.getFromUserInput
		edge_name = "user_input*#{node.getIndex}"
		edge = Edge.new(nil, node, "param")
		$dataflow_source.addDataflowEdge(edge)	
		if $dataflow_edges[edge_name] == nil
			$dataflow_edges[edge_name] = Array.new
		end
		$dataflow_edges[edge_name].push(edge)
		return
	end

	to_ins.getDeps.each do |dep|
		if dep.getInstrHandler == nil
			puts "Handler nil: BB#{dep.getBlock}.#{dep.getInstr}"
		end
		#TODO: getINode == nil, if this instr hasn't been handled yet...
		if dep.getInstrHandler.getINode != nil
			edge_name = "#{dep.getInstrHandler.getINode.getIndex}*#{node.getIndex}"
			edge = Edge.new(dep.getInstrHandler.getINode, node, dep.getVname)
			dep.getInstrHandler.getINode.addDataflowEdge(edge)
			if $dataflow_edges[edge_name] == nil
				$dataflow_edges[edge_name] = Array.new
			end
			$dataflow_edges[edge_name].push(edge)
		end
	end
end

def handle_single_call_node2(start_class, start_function, class_handler, call, level)
	
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
			$cur_node.setIsQuery
			$cur_node.setLabel
			caller_class = nil
			if class_handler.getMethodVarMap[start_function] != nil
				caller_class = class_handler.getMethodVarMap[start_function].search_var(call.getObjName)
			end
			if caller_class == nil
				caller_class = call.getTableName
			end
			
			if trigger_save?(call) or trigger_create?(call)
				temp_actions = Array.new
				if caller_class != nil and trigger_save?(call)
					$class_map[caller_class].getSave.each do |save_action|
						temp_actions.push(save_action)
					end
				end
				if caller_class != nil and trigger_create?(call)
						$class_map[caller_class].getCreate.each do |create_action|
							temp_actions.push(create_action)
						end
				end

				last_cfg = nil
				temp_node = $cur_node
				temp_actions.each do |action|
						temp_name = "#{caller_class}.#{action.getFuncName}"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)
							cur_cfg = trace_query_flow(caller_class, action.getFuncName, "", "", level+2)
							if cur_cfg != nil
								if last_cfg == nil
									temp_node.addChild(cur_cfg.getBB[0].getInstr[0].getINode)
								else
									last_cfg.getReturns.each do |r|
										r.addChild(cur_cfg.getBB[0].getInstr[0].getINode)
									end
								end
								last_cfg = cur_cfg
							end
						end
				end
			end
				
		elsif callerv != nil	
			temp_name = "#{callerv_name}.#{call.getFuncName}"

			if $non_repeat_list.include?(temp_name) == false
				if is_repeatable_function(call.getFuncName)==false
					$non_repeat_list.push(temp_name)
				end
				temp_node = $cur_node	
				cur_cfg = trace_query_flow(callerv_name, call.getFuncName, pass_params, pass_returnv, level+1)
				if cur_cfg != nil
					temp_node.addChild(cur_cfg.getBB[0].getInstr[0].getINode)
					cur_cfg.getReturns.each do |rt|
						dataflow_edge_name = "#{rt.getIndex}*#{temp_node.getIndex}*returnv"
						edge = Edge.new(rt, temp_node, "returnv")
						$dataflow_edges[dataflow_edge_name] = edge
					end
				end
			end
		end

end

def handle_single_instr2(start_class, start_function, class_handler, function_handler, instr, level, return_list)
	node = INode.new(instr)
	blank = ""
	for i in (0...level)
		blank = blank + "\t"
	end
	#puts "#{blank}Instr: ##{node.getIndex} #{node.getInstr.toString} (#{node.getInstr.getFromUserInput})"
	return_list.each do |r|
		r.addChild(node)
	end
	$cur_node = node
	$node_list.push($cur_node)
	add_dataflow_edge(node)
	$ins_cnt += 1

	if instr.instance_of?Call_instr
		call = call_match_name(instr.getResolvedCaller, instr.getFuncname, function_handler)
		if call != nil
			instr.setCallHandler(call)
			if instr.getResolvedCaller.include?("self")
				instr.setResolvedCaller(start_class)
			end

			handle_single_call_node2(start_class, start_function, class_handler, call, level)
		end
	end

	new_return_l = Array.new	
	if instr.hasClosure?
		cl = instr.getClosure
		temp_node = $cur_node
		#puts "CLOSURE: "
		$closure_stack.push(cl)
		handle_single_cfg2(start_class, start_function, class_handler, function_handler, cl, level) 
		$closure_stack.pop
		cl.getReturns.each do |r|
			new_return_l.push(r)
		end
		temp_node.addChild(cl.getBB[0].getInstr[0].getINode)
	elsif
		new_return_l.push($cur_node)
	end
	return new_return_l
end

def handle_single_bb2(start_class, start_function, class_handler, function_handler, bb, level)
#	print "\tBB: #{bb.getIndex}, outgoings:"
#	bb.getOutgoings.each do |o|
#		print "#{o}, "
#	end
#	puts ""

	r_list = Array.new	
	if bb.getInstr.length == 0
		empty_instr = Instruction.new
		bb.addInstr(empty_instr)	
	end
	bb.getInstr.each do |instr|
		r_list = handle_single_instr2(start_class, start_function, class_handler, function_handler, instr, level, r_list)	
	end
	bb.getInstr.each do |instr|
		if instr.instance_of?Return_instr
			r_list.push(instr.getINode)
		end
	end

	#puts "instr #{$cur_node.getIndex}.return length = #{r_list.length}"	
	#The last instr's return list plus all return instrs.
	r_list.each do |r|
		bb.addReturn(r)
	end
end

def handle_single_cfg2(start_class, start_function, class_handler, function_handler, cfg, level)
	#puts "CFG: #{class_handler.getName}.#{function_handler.getName}"
	
	cfg.getBB.each do |bb|
		handle_single_bb2(start_class, start_function, class_handler, function_handler, bb, level)
	end	

	cfg.getBB.each do |bb|
		#puts "BB's return length = #{bb.getReturns.length}"
		bb.getOutgoings.each do |o|
			o_bb = cfg.getBBByIndex(o)
			
			#Add data flow for branching instr
			if bb.getInstr[-1].instance_of?Branch_instr
				o_bb.getInstr.each do |ins|
					edge_name = "#{bb.getInstr[-1].getINode.getIndex}*#{ins.getINode.getIndex}"
					edge = Edge.new(bb.getInstr[-1].getINode, ins.getInode, "_branch_", true)	
					if $dataflow_edges[edge_name] == nil
						$dataflow_edges[edge_name] = Array.new
					end
					$dataflow_edges[edge_name].push(edge)
				end
			end		
	
			#Add edge to instruction node
			bb.getReturns.each do |r|
				r.addChild(o_bb.getInstr[0].getINode)
				#puts "ADD BLOCK CONNECT: #{r.getIndex} -> #{o_bb.getInstr[0].getINode.getIndex}"	
			end
		end
	end

	#TODO: now assume the last BB is the only outage of CFG
	cfg.getBB[-1].getReturns.each do |r|
		cfg.addReturn(r)
	end

end

def trace_query_flow(start_class, start_function, params, returnv, level)
	
	class_handler = $class_map[start_class]
	function_handler = class_handler.getMethods[start_function]

	if function_handler == nil
		if is_transaction_function(start_function)
			#if start_function.include?("begin")
			#	puts "#{$blank}======transaction begin====="
			#else
			#	puts "#{$blank}======transaction end====="
			#end
		end
		#puts "function #{start_class}.#{start_function} cannot be found"
		return nil 
	end

		
	#before_filter_name = "#{start_class}.before_filter"
	#if $non_repeat_list.include?(before_filter_name) == false
	#	$non_repeat_list.push(before_filter_name)

	#	cur_cfg = trace_query_flow(start_class, "before_filter", "", "", level)
	#	
	#	if ($cur_node != nil)
	#		$cur_node.addChild(cur_cfg.getBB[0].getInstr[0].getINode)
	#	else
	#		root = cur_cfg.getBB[0].getInstr[0]
	#	end
	#end

	if function_handler.getCFG != nil
		handle_single_cfg2(start_class, start_function, class_handler, function_handler, function_handler.getCFG, level)
		return function_handler.getCFG
	else
		cfg = CFG.new
		bb = Basic_block.new(1)
		function_handler.getCalls.each do |c|
			call_instr = Call_instr.new(c.getObjName, c.getFuncName)
			bb.addInstr(call_instr)
		end
		cfg.addBB(bb)
		handle_single_cfg2(start_class, start_function, class_handler, function_handler, cfg, level)
		return cfg
	end
end

$global_check = Hash.new

def traverse_instr_tree(node, level)
	if $global_check.has_key?(node.getIndex)
		return
	end
	$global_check[node.getIndex] = node
	node.getChildren.each do |c|
		#if c.isQuery?
		#	puts "QUERY: #{c.getInstr.getCaller}.#{c.getInstr.getFuncname}"
		#end
		blank = ""
		
		for i in (0...level)
			blank = blank + " "
		end
		#puts "#{blank}#{c.getInstr.toString}"
		traverse_instr_tree(c, level + 1)
	end
end

$cur_query_stack = Array.new

$query_edges = Array.new

def is_directly_connected(node1, node2)
	if $global_check.has_key?(node1.getIndex)
		return false
	end
	$global_check[node1.getIndex] = node1
	node1.getChildren.each do |c|
		if c == node2
			return true
		elsif c.isQuery? == false and is_directly_connected(c, node2)
			return true
		end
		#if is_directly_connected(c, node2)
		#	if c.isQuery? == true
		#		puts "n#{c.getIndex} -> n#{node2.getIndex}"
		#	else
		#		return true
		#	end
		#end
	end
	return false
end

