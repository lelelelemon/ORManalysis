#Dataflow trace rules: (starting_node)
#temp_node.getBackwardEdges.each do |e|
#		if e.getFromNode != nil and @proessed.include?(e.getFromNode) == false and e.getFromNode.getIndex < starting_node.getIndex
#			@temp_node_list.push(e.getFromNode)

#temp_node.getDataflowEdges.each do |e|
#		if @processed.include?(e.getToNode) == false
#			if e.getToNode.getInstr.instance_of?Return_instr
#				e.getToNode.getDataflowEdges.each do |e1|
#					if @processed.include?e1.getToNode == false and e1.getToNode.getIndex > starting_node.getIndex
#						@temp_node_list.push(e1.getToNode)
#					end
#				end
#			elsif e.getToNode.getIndex > starting_node.getIndex
#				@temp_node_list.push(e.getToNode)
#			end
#		end


def isAttrAssign(node)
	if node.getInstr.instance_of?AttrAssign_instr
		if node.getInstr.getFuncname.index('!') == nil
			return true
		end
	end
	return false  
end

def isTableAttrAssign(node)
	if node.getInstr.instance_of?AttrAssign_instr
		if node.getInstr.getFuncname.index('!') == nil
			_caller = nil
			if node.getInstr.getCallHandler!= nil
				_caller = node.getInstr.getCallHandler.caller
			end
			if _caller != nil and isActiveRecord(_caller.getName)
				return true
			elsif _caller == nil
				#puts "Attr assign UNKNOWN caller: #{node.getIndex}:#{node.getInstr.toString}  #{node.getInstr.getCallHandler == nil} "
			else
				#puts "Not active record: #{node.getIndex}:#{node.getInstr.toString}"
			end
		end
	end
	return false  
end

def find_all_ancestors(nodex)
	@ancestors = Array.new
	@temp_node_list = Array.new
	@temp_node_list.push(nodex)
	while @temp_node_list.length > 0
		temp_node = @temp_node_list.shift
		@ancestors.push(temp_node)
		if temp_node.isReadQuery?
		else
			temp_node.getBackwardEdges.each do |e|
				if e.getFromNode != nil and @ancestors.include?(e.getFromNode) == false and e.getFromNode.getIndex < nodex.getIndex
					@temp_node_list.push(e.getFromNode)
				end
			end
		end
	end	
	return @ancestors
end

class Func_dep_expression
	def initialize
		#(a^b^c) V (d^e....^h) V (...^...)
		@clauses = Array.new
		@cur_clause = nil
	end
	attr_accessor :clauses
	def create_new_clause	
		if @cur_clause == nil
			@cur_clause = Array.new
		else
			@clauses.push(@cur_clause)
			@cur_clause = Array.new
		end
	end
	def addLiteral(node)
		if @cur_clause.include?(node)
		else
			@cur_clause.push(node)
		end
	end
end

def compute_functional_dependency(file_to_write)
	@func_dep_map = Hash.new
	for i in 0...$node_list.length-1
		n = $node_list[i]
		if isTableAttrAssign(n)
			if @func_dep_map[n] == nil
				@func_dep_map[n] = Func_dep_expression.new
				@func_dep_map[n].create_new_clause
			else
				@func_dep_map[n].create_new_clause
			end
			@ancestors = find_all_ancestors(n)
			include_user_input = false
			@ancestors.each do |a|
				if a.getInstr.getFromUserInput
					include_user_input = true
				end
				if (isTableAttrAssign(a) or a.isField?) and a.getInstr.getCallHandler != nil and a.getInstr.getCallHandler.caller != nil and a != n
					field_name = a.getInstr.getCallHandler.getFuncName
					tbl_name = a.getInstr.getCallHandler.caller.getName
					if testTableField(tbl_name, field_name)
						@func_dep_map[n].addLiteral(a)
					end
				end
			end
			if include_user_input
				@func_dep_map[n] = nil
			end
		end
	end

	@func_dep_map.each do |k, v|
		v.create_new_clause
		v.clauses.each do |ary|
			if ary.length > 0
				callera = k.getInstr.getCallHandler
				file_to_write.write("FUNCDEP: #{callera.caller.getName}.#{callera.getFuncName} -> ")
				puts "#{k.getIndex}: #{callera.caller.getName}.#{callera.getFuncName} < #{k.getInstr.toString} >"
				ary.each do |n1|
					callerb	= n1.getInstr.getCallHandler
					file_to_write.write("#{callerb.caller.getName}.#{callerb.getFuncName} ")
					puts "\t#{n1.getIndex}: 	#{callerb.caller.getName}.#{callerb.getFuncName} < #{n1.getInstr.toString} >"
				end
				file_to_write.write("\n")
			end
		end
	end
end

#nodex is before nodey
=begin
def test_functional_dependency(nodex, nodey)
	#TODO: First should check nodex and nodey appeared more than twice
	#TODO: Check if nodex and nodey belong to the same table, whether they belong to the same class instance
	
	#check whether nodex and nodey have common sources
	sources_overlap = false
	nodex.source_list.each do |s|
		if nodey.source_list.include?s
			sources_overlap = true
		end
	end
	if sources_overlap == false
		return nil
	end

	@nodex_ancestors = find_all_ancestors(nodex)
	@nodey_ancestors = find_all_ancestors(nodey)

	@nearest_common_ancestor = nil	

	ancestors_overlap = false
	@nodex_ancestors.each do |a|
		if @nodey_ancestors.include?(a)
			if @nearest_common_ancestor == nil or @nearest_common_ancestor.getIndex < a.getIndex
				if a.getIndex <= nodex.getIndex
					@nearest_common_ancestor = a
				end
			end
		end
	end

	#puts "#{nodex.getIndex}:#{nodex.getInstr.toString} and #{nodey.getIndex}:#{nodey.getInstr.toString}"
	#puts "\t+++++ NEAREST ancestor: "
	if @nearest_common_ancestor != nil
		#puts "\t\t****   #{@nearest_common_ancestor.getIndex}: #{@nearest_common_ancestor.getInstr.toString}"
	end

	if @nearest_common_ancestor != nil 
		if @nearest_common_ancestor != nodex
			@reversible_path = find_path_between_two_nodes(@nearest_common_ancestor, nodex)
			#If nodex is not common ancestor, then the data path from common ancestor to nodex must be reversible
			reversible = true
			@reversible_path.each do |r|
				cond = false
				if r.getBackwardEdges.length > 1
					r.getBackwardEdges.each do |e|
						if e.getFromNode.getIndex < r.getIndex and @reversible_path.include?(e.getFromNode)==false
							reversible = false
						end
					end
				end
			end
			for i in 1...@reversible_path.length
				prevn = @reversible_path[i-1]
				prevn.getDataflowEdges.each do |e|
					if e.getToNode == @reversible_path[i]
						if e.getVname.index('%') == nil
							reversible = false
						elsif e.getVname == "%self"
							reversible = false
						end
					end
				end	
			end
			if reversible == false
				@nearest_common_ancestor = nil
			end
		end
	end

	return @nearest_common_ancestor
end

def compute_functional_dependency(file_to_write)
	for i in 0...$node_list.length-1
		n = $node_list[i]
		if isTableAttrAssign($node_list[i])
			for j in i+1...$node_list.length-1
				if isTableAttrAssign($node_list[j])

					ancestor = test_functional_dependency($node_list[i], $node_list[j])
					if ancestor != nil
						#HAVE functional dependency!
						#puts "!!! FIND a functional dependency! #{i} -> #{j}"
						callera = $node_list[i].getInstr.getCallHandler
						callerb = $node_list[j].getInstr.getCallHandler
						file_to_write.write("FUNCDEP: W #{callera.caller.getName}.#{callera.getFuncName} -> #{callerb.caller.getName}.#{callerb.getFuncName}\n")	
					end
				end
			end
		elsif $node_list[i].isField? and n.getInstr.getCallHandler != nil and n.getInstr.getCallHandler.caller != nil
			var_name = n.getInstr.getCallHandler.getObjName
			field_name = n.getInstr.getCallHandler.getFuncName
			tbl_name = n.getInstr.getCallHandler.caller.getName
			if testTableField(tbl_name, field_name)
				for j in i+1...$node_list.length-1
					if isTableAttrAssign($node_list[j])
						ancestor = test_functional_dependency($node_list[i], $node_list[j])
						if ancestor == $node_list[i]
							#HAVE functional dependency!
							#puts "!!! FIND a functional dependency! #{i} -> #{j}"
							callera = $node_list[i].getInstr.getCallHandler
							callerb = $node_list[j].getInstr.getCallHandler
							if callera != nil
								file_to_write.write("FUNCDEP: R #{callera.caller.getName}.#{callera.getFuncName} -> #{callerb.caller.getName}.#{callerb.getFuncName}\n")	
							end
						end
					end
				end
			end
		end
	end
end
=end
