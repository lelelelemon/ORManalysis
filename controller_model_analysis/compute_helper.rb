def isAttrAssign(node)
	if node.getInstr.instance_of?AttrAssign_instr
		if node.getInstr.getFuncname.index('!') == nil
			return true
		end
	end
	return false  
end

def isTableAttrAssign(n)
	if n.getInstr.instance_of?AttrAssign_instr
		tbl_name = type_valid(n.getInstr, n.getInstr.getCaller)
		field_name = n.getInstr.getFuncname
		if tbl_name != nil
			if testTableField(tbl_name, field_name)
				return true
			end
		end
	end
	return false
end


#Dataflow trace rules: (starting_node)
#temp_node.getBackwardEdges.each do |e|
#		if e.getFromNode != nil and @proessed.include?(e.getFromNode) == false and e.getFromNode.getIndex < starting_node.getIndex
#			@temp_node_list.push(e.getFromNode)

#temp_node.getDataflowEdges.each do |e|
#		if @processed.include?(e.getToNode) == false
#			if e.getToNode.getInstr.instance_of?Return_instr
# 			tonode = e.getToNode.getDataflowEdges[0].getToNode
#				toNode.getDataflowEdges.each do |e1|
#					if @processed.include?e1.getToNode == false and e1.getToNode.getIndex > starting_node.getIndex
#						@temp_node_list.push(e1.getToNode)
#					end
#				end
#			elsif e.getToNode.getIndex > starting_node.getIndex
#				@temp_node_list.push(e.getToNode)
#			end
#		end

def traceback_data_dep(cur_node, stop_at_query=false)
	@dep_array = Array.new
	@node_list = Array.new
	@node_list.push(cur_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		node.getBackwardEdges.each do |e|
			if e.getFromNode != nil and e.getToNode != nil
				if e.getFromNode.isReadQuery?
					if @dep_array.include?(e.getFromNode)
					else
						@dep_array.push(e.getFromNode)
					end
					if stop_at_query
						return e.getFromNode
					end	
				else
					#if cur_node.getCallStack.include?(e.getToNode) and e.getVname == "returnv"
					if e.getFromNode.getInstr.instance_of?Return_instr and e.getFromNode.getInstr.getClassName == cur_node.getInstr.getClassName and e.getFromNode.getInstr.getMethodName == cur_node.getInstr.getMethodName
					elsif e.getFromNode.getIndex < cur_node.getIndex
					#else
						#test is both nodes are in the same basic block, prevent from tracing too far
						#if e.getFromNode.getInstr.getBB == node.getInstr.getBB
						if @dep_array.include?(e.getFromNode)
						else
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
		@total = 0
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
				elsif e.getToNode.getInstr.hasClosure?
					return e.getToNode
				end
			elsif e.getToNode.getInstr.instance_of?AttrAssign_instr and e.getToNode.getInstr.getCaller.include?("self")
				return e.getToNode
			elsif e.getToNode.getInstr.hasClosure?
				return e.getToNode
			else
				if @node_list.include?(e.getToNode) or @traversed.include?(e.getToNode)
				else
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
	if query_node.getInstr.getBB.getCFG.getMHandler.normal_function == false
		query_node.getDataflowEdges.each do |e|
			@node_list.push(e.getToNode)
		end
	end
	while @node_list.length > 0 do
		node = @node_list.pop
		if @traversed.include?(node)
		else
			@traversed.push(node)
		end
		if node.getInstr.instance_of?Return_instr
			toedge = node.getDataflowEdges[0]
			if toedge and toedge.getToNode
				toedge.getToNode.getDataflowEdges.each do |e1|
					if e1.getToNode.getIndex <= query_node.getIndex or @traversed.include?(e1.getToNode)
					else
						@node_list.push(e1.getToNode)
					end
				end	
			end
		else
			node.getDataflowEdges.each do |e|	
				if e.getToNode.isQuery? and e.getToNode != query_node
					if @traversed.include?(e.getToNode)
					else
						@traversed.push(e.getToNode)
						@node_list.push(e.getToNode)
					end
				elsif @node_list.include?(e.getToNode) or @traversed.include?(e.getToNode)
				else
					if e.getToNode.getInstr.instance_of?Return_instr
						toedge = e.getToNode.getDataflowEdges[0]
						if toedge and toedge.getToNode
							toedge.getToNode.getDataflowEdges.each do |e1|
								if e1.getToNode.getIndex <= query_node.getIndex or @traversed.include?(e1.getToNode)
								else
									@node_list.push(e1.getToNode)
								end
							end	
						end
					elsif e.getToNode.getIndex > query_node.getIndex
						@node_list.push(e.getToNode)
					end
				end
			end
		end
	end
	@traversed.shift
	return @traversed
end

def find_all_ancestors(nodex)
	@ancestors = Array.new
	@temp_node_list = Array.new
	@temp_node_list.push(nodex)
	while @temp_node_list.length > 0
		temp_node = @temp_node_list.shift
		@ancestors.push(temp_node)
		temp_node.getBackwardEdges.each do |e|
			if e.getFromNode != nil and @ancestors.include?(e.getFromNode) == false 
				if e.getFromNode.getInstr.instance_of?Return_instr and e.getFromNode.getInstr.getClassName == nodex.getInstr.getClassName and e.getFromNode.getInstr.getMethodName == nodex.getInstr.getMethodName
				elsif e.getFromNode.getIndex < nodex.getIndex
					@temp_node_list.push(e.getFromNode)
				end
			end
		end
	end
	return @ancestors
end

def find_all_succcessors(nodex)
	@successors = Array.new
	@temp_node_list = Array.new
	@temp_node_list.push(nodex)
	while @temp_node_list.length > 0 do
		node = @temp_node_list.pop
		if node != nodex
			@successors.push(node)
		end
		if node.getInstr.instance_of?Return_instr
			toedge = node.getDataflowEdges[0]
			if toedge and toedge.getToNode
				toedge.getToNode.getDataflowEdges.each do |e1|
					if e1.getToNode.getIndex <= nodex.getIndex or @successors.include?(e1.getToNode)
					else
						@temp_node_list.push(e1.getToNode)
					end
				end	
			end
		else
			node.getDataflowEdges.each do |e|
				if @successors.include?(e.getToNode)
				else
					@temp_node_list.push(e.getToNode)
				end
			end
		end
	end
	return @successors
end


#node is the assignment of a local variable, v_name is the name of the variable
#when a query result is stored in a variable, like @comment, check if there is any function call by @comment
#If yes, then the complete result need to be returned, or else only boolean or certain fields needs to be returned
#TODO: not finished...
def check_necessary_materialization(v_name, node)
	#get all predecessors of node
	@successors = find_all_successors(node)
	@successors.each do |p|
		if node.getInstr.getClassName == p.getInstr.getClassName
			if p.getInstr.instance_of?Call_instr #Has to be strictly Call_instr, not using is_a
				#TODO: caller name match, complicated...
				return true
			end 
		end
	end 	
	return false		
end

def is_chained_query(qnode)
	qnode.getDataflowEdges.each do |e|
		if e.getToNode.isReadQuery? and qnode.getDataflowEdges.length == 1
			return true
		end
	end
	return false
end

