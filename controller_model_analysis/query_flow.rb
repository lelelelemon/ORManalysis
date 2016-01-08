#load 'read_dataflow.rb'
$in_view = false
$in_loop = Array.new
$funccall_stack = Array.new

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
		@in_view = $in_view	
		@in_loop = ($in_loop.length > 0)	
		@closure_stack = Array.new
		@dataflow_edges = Array.new
		@backward_dataflow_edges = Array.new
		r = Random.new
		@rnd = r.rand(1...1024)
		if $closure_stack.length > 0
			@in_closure = true
			$closure_stack.each do |cl|
				@closure_stack.push(cl)
			end
		end
	end
	def getClosureStack
		@closure_stack
	end
	def getInView
		@in_view
	end
	def getInLoop
		@in_loop
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
			return @instr.isQuery
		end
		return false
	end
	def isField?
		if @instr != nil and @instr.instance_of?Call_instr
			return @instr.isField
		end
		return false
	end
	def isBranch?
		if @instr != nil and @instr.instance_of?Branch_instr
			return true
		end
		return false
	end
	def setLabel
		#if isQuery?
			#if @instr.getResolvedCaller.length > 0
			#	@label = "#{@instr.getResolvedCaller}.#{@instr.getFuncname}"
			#else
			#	@label = "#{@instr.getCaller}.#{@instr.getFuncname}"
			#end
		#elsif @instr.instance_of?Call_instr
		#	@label = "#{@instr.getCaller}.#{@instr.getFuncname}"
		#end

		if @instr.instance_of?Call_instr 
			if@instr.getCallHandler != nil
				@label = "#{remove_special_chars(@instr.getCallHandler.getObjName)}.#{@instr.getFuncname}"
			else
				@label = "#{remove_special_chars(@instr.getCaller)}.#{@instr.getFuncname}"
			end
		end
	end
	def getLabel
		@label
	end
	def getSimplifiedLabel
		if isQuery?
			if @instr.getResolvedCaller.length > 0
				return "#{@instr.getResolvedCaller}.#{@instr.getFuncname.delete('!').delete('?')}"
			else
				return "#{@rnd}.#{@instr.getFuncname.delete('!').delete('?')}"
			end
		else
			return ""
		end
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
						temp_actions.push("before_save")
						temp_actions.push("before_validation")
				end
				if caller_class != nil and trigger_create?(call)
							temp_actions.push("before_create")
				end

				last_cfg = nil
				temp_node = $cur_node
				temp_actions.each do |action|
						temp_name = "#{caller_class}.#{action}"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)
							if callerv != nil and $class_map[callerv.getUpperClass] != nil
								cur_cfg = trace_query_flow(callerv.getUpperClass, action, "", "", level+2)
								#TODO: add control flow edges...
							end
							cur_cfg = trace_query_flow(caller_class, action, "", "", level+2)
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
			temp_name = "#{callerv.getName}.#{call.getFuncName}"

			if $non_repeat_list.include?(temp_name) == false
				if is_repeatable_function(call.getFuncName)==false
					$non_repeat_list.push(temp_name)
				end
				temp_node = $cur_node	
				cur_cfg = trace_query_flow(callerv.getName, call.getFuncName, pass_params, pass_returnv, level+1)
				if cur_cfg != nil
					temp_node.addChild(cur_cfg.getBB[0].getInstr[0].getINode)
					cur_cfg.getExplicitReturn.each do |rt|
						dataflow_edge_name = "#{rt.getIndex}*#{temp_node.getIndex}*returnv"
						edge = Edge.new(rt, temp_node, "returnv")
						#puts "Add return instr: #{callerv_name}.#{call.getFuncName} #{rt.getIndex} -> #{temp_node.getIndex}"
						
						rt.getInstr.getINode.addDataflowEdge(edge)
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
			$funccall_stack.push($cur_node)
			handle_single_call_node2(start_class, start_function, class_handler, call, level)
			$funccall_stack.pop
		end
	end

	if instr.instance_of?ReceiveArg_instr
		if $funccall_stack.length > 0
			dep = $funccall_stack[-1]
			edge_name = "#{dep.getIndex}*#{node.getIndex}"
			edge = Edge.new(dep, node, instr.var_name)
			dep.addDataflowEdge(edge)
			if $dataflow_edges[edge_name] == nil
				$dataflow_edges[edge_name] = Array.new
			end
			$dataflow_edges[edge_name].push(edge)
		end
	end

	new_return_l = Array.new	
	if instr.hasClosure?
		cl = instr.getClosure
		temp_node = $cur_node
		if cl.getViewClosure
			$in_view = true
		else
			$in_loop.push(true)
		end
		$closure_stack.push($cur_node)
		handle_single_cfg2(start_class, start_function, class_handler, function_handler, cl, level) 
		$closure_stack.pop
		cl.getReturns.each do |r|
			new_return_l.push(r)
		end
		if cl.getViewClosure
			$in_view = false
		else
			$in_loop.pop
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
			bb.addExplicitReturn(instr.getINode)
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
					edge = Edge.new(bb.getInstr[-1].getINode, ins.getINode, "_branch_", true)	
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

			bb.getExplicitReturn.each do |r|
				cfg.addExplicitReturn(r)
			end
			
			#control flow outage point
			#TODO: return instr is not handled, sometimes the outage point may be return instrs
			if bb.getOutgoings.length == 0
				cfg.addReturn(r)
			end
		end
	end

end

def trace_query_flow(start_class, start_function, params, returnv, level)
	
	class_handler = $class_map[start_class]
	if class_handler != nil
		function_handler = class_handler.getMethod(start_function)
	else
		function_handler = nil
	end

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

	
	#TODO: Before filter is not handled here, since most of them just do validation and are not involved in dataflow	
	before_filter_name = "#{start_class}.before_filter"
	if $non_repeat_list.include?(before_filter_name) == false
		$non_repeat_list.push(before_filter_name)

		cfg = CFG.new
		bb = Basic_block.new(1)
		filter_handler = $class_map[start_class].getMethods["before_filter"]
		if filter_handler != nil	
			filter_handler.getCalls.each do |c|
				call_instr = Call_instr.new(c.getObjName, c.getFuncName)
				bb.addInstr(call_instr)
			end
			cfg.addBB(bb)
			handle_single_cfg2(start_class, "before_filter", class_handler, filter_handler, cfg, level)
		end
	end

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

