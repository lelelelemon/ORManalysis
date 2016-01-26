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
		@call_stack = Array.new
		@dataflow_edges = Array.new
		@controlflow_edges = Array.new
		@backward_dataflow_edges = Array.new
		@backward_controlflow_edges = Array.new
		@Tnode = nil
		@source_list = Array.new
		@sink_list = Array.new
		r = Random.new
		@rnd = r.rand(1...1024)
		if $closure_stack.length > 0
			@in_closure = true
			$closure_stack.each do |cl|
				@closure_stack.push(cl)
			end
		end
		$funccall_stack.each do |f|
			@call_stack.push(f)
		end
	end
	attr_accessor :index, :Tnode, :source_list, :sink_list
	def getClosureStack
		@closure_stack
	end
	def getCallStack
		@call_stack
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
	def addBackwardControlEdge(edge)
		@backward_controlflow_edges.push(edge)
	end
	def addControlflowEdge(edge)
		@controlflow_edges.push(edge)
		edge.getToNode.addBackwardControlEdge(edge)
	end
	def getControlflowEdges
		@controlflow_edges
	end
	def getBackwardControlEdges
		@backward_controlflow_edges
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
	def isReadQuery?
		if @instr != nil and @instr.instance_of?Call_instr
			return @instr.isReadQuery
		end
		return false
	end
	def isWriteQuery?
		return (isQuery? and (!isReadQuery?))
	end
	def isField?
		if @instr != nil and (@instr.is_a?Call_instr)
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

		if @instr.is_a?Call_instr 
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
						#puts "Add return instr: #{callerv_name}.#{call.getFuncName} #{rt.getIndex} -> #{temp_node.getIndex}"
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
class Dataflow_edge
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

class Controlflow_edge
	def initialize(fromn, ton)
		@from_node = fromn
		@to_node = ton
	end
	def getFromNode
		@from_node
	end
	def getToNode
		@to_node
	end
end

def add_dataflow_edge(node)
	to_ins = node.getInstr
	if to_ins.getFromUserInput
		edge_name = "user_input*#{node.getIndex}"
		edge = Dataflow_edge.new(nil, node, "param")
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
			#XXX: If it is a field instr, then we know it is not a blackbox func call, if it is not attrassign, then it is a read only instr
			from_node = dep.getInstrHandler.getINode
			if from_node.getInstr.instance_of?Call_instr and from_node.getInstr.isField and dep.getVname == "%self"
			elsif to_ins.instance_of?Return_instr and dep.getVname == "%self"
			else
				edge_name = "#{dep.getInstrHandler.getINode.getIndex}*#{node.getIndex}"
				edge = Dataflow_edge.new(dep.getInstrHandler.getINode, node, dep.getVname)
				dep.getInstrHandler.getINode.addDataflowEdge(edge)
				if $dataflow_edges[edge_name] == nil
					$dataflow_edges[edge_name] = Array.new
				end
				$dataflow_edges[edge_name].push(edge)
			end
		end
	end
end

def addAllControlEdges
	for i in 1...$node_list.length
		pren = $node_list[i-1]
		curn = $node_list[i]
		if pren.getInstr and curn.getInstr
			if pren.getInstr.instance_of?Call_instr
				edge = Controlflow_edge.new(pren, curn)
				pren.addControlflowEdge(edge)
			elsif pren.getInstr.getBB == curn.getInstr.getBB
				edge = Controlflow_edge.new(pren, curn)
				pren.addControlflowEdge(edge)
			elsif pren.getInstr != nil and pren.getInstr == pren.getInstr.getBB.getInstr[-1]
				#Since for each CFG, there is always a control flow edge from the first BB to last BB, 
				#I want to remove this edge.
				tmp_cnt = 0
				#If there is only one BB, then it is not from the dataflow log
				cond = (pren.getInstr.getBB.getCFG.getBB.length > 1 and pren.getInstr.getBB.getIndex == 1)
				pren.getInstr.getBB.getOutgoings.each do |o|
					if cond and tmp_cnt == 0
					else
						o_bb = pren.getInstr.getBB.getCFG.getBBByIndex(o)
						next_node = o_bb.getInstr[0].getINode
						edge = Controlflow_edge.new(pren, next_node)
						pren.addControlflowEdge(edge)
					end
					tmp_cnt += 1
				end
			end
		end
	end
end


