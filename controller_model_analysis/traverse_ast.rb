def traverse_ast(astnode, level)
	@blank = ""
	for i in (0...level)
		@blank = @blank + "   "
	end
	if astnode.class.to_s == "YARD::Parser::Ruby::MethodDefinitionNode"
		@method_name = astnode.children[0].source.to_s
		if @method_name == "self"
			@method_name = astnode.children[2].source.to_s
		end
		$cur_method = Method_class.new(@method_name)
		$cur_class.addMethod($cur_method)
		#puts "def method_name = #{@method_name}"
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
		$cur_method = nil
	elsif astnode.class.to_s == "YARD::Parser::Ruby::ConditionNode"
		i = 0
		astnode.children.each do |child|
			if i==0
				$cur_position = "INCONDITION"
					traverse_ast(child, level+1)
				$cur_position = ""
			else
				traverse_ast(child, level+1)
			end
			i = i + 1
		end
	elsif astnode.class.to_s == "YARD::Parser::Ruby::MethodCallNode"
		temp_funccall = parse_method_call(astnode, $cur_method)
		if $cur_position == "INCONDITION" and $cur_funccall != nil
			$cur_funccall.setReturnValue("true")
		end
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
		return temp_funccall
	elsif (astnode.type.to_s == "assign" or astnode.type.to_s == "opassign")
		if $cur_method != nil
			assigned_var = parse_assign(astnode, $cur_method)
			astnode.children.each do |child|
				if child.class.to_s == "YARD::Parser::Ruby::MethodCallNode"
					temp_funccall = traverse_ast(child, level+1)
					if temp_funccall != nil
						temp_funccall.setReturnValue(assigned_var)			
						#if it is a new method, then we know the class type of the variable. This is kind of type inference
						if ["new", "new!"].include?temp_funccall.getFuncName
							$cur_class.addMethodVar($cur_method.getName, assigned_var, temp_funccall.getObjName)
						end
						#if temp_funccall.isQuery and searchTableName(temp_funccall.getObjName) != nil
						if searchTableName(temp_funccall.getObjName) != nil
							#puts "NEW method: (#{$cur_class.getName}.#{$cur_method.getName}) #{assigned_var} = (#{temp_funccall.getObjName}) =====> #{searchTableName(temp_funccall.getObjName)} . #{temp_funccall.getFuncName}"
							$cur_class.addMethodVar($cur_method.getName, assigned_var, searchTableName(temp_funccall.getObjName))
						end
					end
				else
					traverse_ast(child, level+1)
				end
			end
		end
	else
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
	end
	
end

