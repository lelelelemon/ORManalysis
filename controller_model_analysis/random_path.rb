require 'date'
load 'util.rb'
class Txn_begin_node < INode
	def initialize
		super(nil)
	end
end

class Txn_end_node < INode
	def initialize
		super(nil)
	end
end

def randomp_handle_single_call_node(start_class, start_function, class_handler, call)
	callerv = call.caller
	#callerv_name = call.findCaller(start_class, start_function)
	#callerv = $class_map[callerv_name]
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

		if trigger_save?(call) or trigger_create?(call)
			node = Txn_begin_node.new
			$cur_node.addChild(node)
			$cur_node = node
			$node_list.push($cur_node)
		end

		temp_actions = Array.new
		if trigger_save?(call)
			temp_actions.push("before_save")
			temp_actions.push("before_validation")
		end
		if trigger_create?(call)
			temp_actions.push("before_create")
		end
		last_cfg = nil
		temp_node = $cur_node
		temp_actions.each do |action|
			temp_name = "#{callerv.getName}.#{action}"
			if $non_repeat_list.include?(temp_name) == false
				$non_repeat_list.push(temp_name)
				last_node = randomp_trace_flow(callerv.getName, action, "", "")
				temp_node.addChild(last_node)
			end
		end
		if trigger_save?(call) or trigger_create?(call)
			node = Txn_end_node.new
			$cur_node.addChild(node)
			$cur_node = node
			$node_list.push($cur_node)
		end

	elsif callerv != nil
		temp_name = "#{callerv.getName}.#{call.getFuncName}"
		if $non_repeat_list.include?(temp_name) == false
			$non_repeat_list.push(temp_name)
		end
		@temp_node = $cur_node
		randomp_trace_flow(callerv.getName, call.getFuncName, pass_params, pass_returnv)
		last_node = $cur_node
		dataflow_edge_name = "#{last_node.getIndex}*#{@temp_node.getIndex}*returnv"
		edge = Edge.new(last_node, @temp_node, "returnv")
		last_node.getInstr.getINode.addDataflowEdge(edge)
		$dataflow_edges[dataflow_edge_name] = edge
	end
end

def randomp_handle_single_instr(start_class, start_function, class_handler, function_handler, instr)
	node = INode.new(instr)
	if $node_list.length == 0
		$root = node
	else
		$cur_node.addChild(node)
	end
	$cur_node = node
	$node_list.push($cur_node)
	add_dataflow_edge(node)
	$ins_cnt += 1

	if instr.instance_of?Call_instr
		puts "Handle call instr(#{$ins_cnt-1}): #{instr.getResolvedCaller} -> #{instr.getFuncname}"
		call = call_match_name(instr.getResolvedCaller, instr.getFuncname, function_handler)
		if call != nil
			instr.setCallHandler(call)
			if instr.getResolvedCaller.include?("self")
				instr.setResolvedCaller(start_class)
			end
			randomp_handle_single_call_node(start_class, start_function, class_handler, call)
		else
			puts "\t\tcaller = nil"
		end
	end

	if instr.hasClosure?
		cl = instr.getClosure
		temp_node = $cur_node
		if cl.getViewClosure
			$in_view = true
		else
			$in_loop.push(true)
		end
		$closure_stack.push(cl)
		last_node = randomp_handle_single_cfg(start_class, start_function, class_handler, function_handler, cl)
		$closure_stack.pop
		if cl.getViewClosure
			$in_view = false
		else
			$in_loop.pop
		end
		temp_node.addChild(last_node)
	end
	return $cur_node
end

def randomp_handle_single_bb(start_class, start_function, class_handler, function_handler, bb)
	if bb.getInstr.length == 0
		empty_instr = Instruction.new
		#TODO: How to deal with empty instr? should be a Call_instr
		bb.addInstr(empty_instr)
	end
	
	bb.getInstr.each do |instr|
		#Assume every randomp_handle_single_instr call will set $cur_node to the current instr node
		randomp_handle_single_instr(start_class, start_function, class_handler, function_handler, instr)
	end
	
	return $cur_node
end

def randomp_handle_single_cfg(start_class, start_function, class_handler, function_handler, cfg)
	#Instead of going over all BB, iterate over outgoing edges and randomly choose one outgoing BB as next BB
	#TODO: Loop in CFG is not handled here. Let's just cross finger and hope the random number will make the loop exit
	puts "Handle func: #{start_class} . #{start_function}"
	temp_BB = cfg.getBB[0]
	bb_list = Array.new
	while temp_BB.getOutgoings.length > 0 do
		bb_list.push(temp_BB)
		#puts "Rand seed: #{(DateTime.now.strftime('%s')).to_i}"
		#XXX: I don't know why in the dataflow the first BB can always go to the last BB, even no branch
		#To make sure the function gets executed, if BB.index == 1, only select from the last outgoing
		if temp_BB.getIndex == 1
			rnd = $fast_random.next_bound(1, temp_BB.getOutgoings.length)
		else
			rnd = $fast_random.next_bound(0,temp_BB.getOutgoings.length)
		end
		puts "\tBB #{temp_BB.getIndex} Outgoings have #{temp_BB.getOutgoings.length} bb, chose #{rnd}"
		last_node = randomp_handle_single_bb(start_class, start_function, class_handler, function_handler, temp_BB)
		temp_BB = cfg.getBBByIndex(temp_BB.getOutgoings[rnd])
	end

	#TODO: add dataflow edge
	bb_list.each do |bb|
	end

	#or return last_node?
	return $cur_node
end

def randomp_trace_flow(start_class, start_function, params, returnv)
	class_handler = $class_map[start_class]
	if class_handler != nil
		function_handler = class_handler.getMethods[start_function]
	else
		function_handler = nil
	end

	if function_handler == nil
		return nil
	end


	before_filter_name = "#{start_class}.before_filter"
	if $non_repeat_list.include?(before_filter_name) == false
		$non_repeat_list.push(before_filter_name)
		fcall = Function_call.new("self", "before_filter")
		puts "#{start_class} . before filter:"
		instr = Call_instr.new("#{start_class}", "before_filter")
		instr.setCallHandler(fcall)
		instr.setResolvedCaller("#{start_class}")
		node = INode.new(instr)
		$cur_node = node
		$node_list.push($cur_node)
		if $root == nil
			$root = $cur_node
		end
		last_node = randomp_handle_single_call_node(start_class, start_function, class_handler, fcall)
	end	

	if function_handler.getCFG != nil
		last_node = randomp_handle_single_cfg(start_class, start_function, class_handler, function_handler, function_handler.getCFG)
	else
		bb = Basic_block.new(1)
		function_handler.getCalls.each do |c|
			call_instr = Call_instr.new(c.getObjName, c.getFuncName)
			call_instr.setResolvedCaller(c.getObjName)
			bb.addInstr(call_instr)
		end
		last_node = randomp_handle_single_bb(start_class, start_function, class_handler, function_handler, bb)
	end
	return $cur_node
end

def print_random_trace(start_class, start_function)
		randomp_trace_flow(start_class, start_function, "", "")
		$node_list.each do |n|
			if n.instance_of?Txn_begin_node 
				puts "=====transaction begin====="
			elsif n.instance_of?Txn_end_node
				puts "=====transaction end====="
			else 
				n.setLabel
				if n.isQuery?
					puts "[QUERY](#{n.getIndex}) #{n.getLabel}" 
				elsif n.getInstr.instance_of?Call_instr
					if n.getInstr.getCallHandler != nil
						f_handler = n.getInstr.getCallHandler
						puts "(#{n.getIndex}) #{f_handler.getObjName} . #{f_handler.getFuncName}"
					end
					#puts "#{n.getInstr.getResolvedCaller} . #{n.getInstr.getFuncname}"
				end
				if n.getInstr.instance_of?Call_instr and n.getInstr.getCallHandler == nil
					puts "\t\t\t * * call handler is nill"
				end
			end				
		end
end
