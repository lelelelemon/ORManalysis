def parse_attrib_node(astnode)
#TODO: currently only handles single attribute node
	return get_left_most_leaf(astnode).source.to_s
end

def parse_attrib(astnode)
	case astnode.children[0].source.to_s
		#when "has_many"
		#	if astnode.children[1].type.to_s == "list"
		#		astnode.children[1].children.each do |child|
		#			if child.type.to_s == "symbol_literal"
		#				$cur_class.addHasMany(parse_attrib_node(child))
		#			end
		#		end
		#	end
		#when "belongs_to"
		#	if astnode.children[1].type.to_s == "list"
		#		astnode.children[1].children.each do |child|
		#			if child.type.to_s == "symbol_literal"
		#				$cur_class.addBelongsTo(parse_attrib_node(child))
		#			end
		#		end
		#	end
		#when "has_one"
		#	if astnode.children[1].type.to_s == "list"
		#		astnode.children[1].children.each do |child|
		#			if child.type.to_s == "symbol_literal"
		#				$cur_class.addHasOne(parse_attrib_node(child))
		#			end
		#		end
		#	end
		when "attr_accessor"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						$cur_class.addVariable(get_left_most_leaf(child).source.to_s)
					end
				end
			end
		when "before_filter"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						$cur_class.addBeforeFilter(get_left_most_leaf(child).source.to_s)
					#puts "#{$cur_class.getName} add before filter: #{get_left_most_leaf(child).source.to_s}"
					end
				end
			end
		when "before_validation"
			method_list = Array.new
			#process_list
			list_child = nil
			astnode.children.each do |child|
				if child.type.to_s == "list" and child.source.to_s.include?("=>")==false
					list_child = child
				end
			end
			if list_child != nil
				if astnode.children[1].type.to_s == "list"
					astnode.children[1].children.each do |child|
						if child.type.to_s == "symbol_literal"
							method_list.push(get_left_most_leaf(child).source.to_s)
						end
					end
				end
			end
			#process block
			block_child = nil
			astnode.children.each do |child|
				if child.type.to_s == "do_block"
					block_child = child
				end
			end

			#TODO: handle before_validation do block
			on_child = nil
			astnode.children.each do |achild|
				if achild.source.include?(":on =>")
					on_child = achild
				end
			end
			if on_child == nil
				astnode.children[1].children.each do |achild|
					if achild.source.include?(":on =>")
						on_child = achild
					end
				end
			end
			if on_child != nil
				#only one [:on]
				if on_child.children[0].type.to_s == "assoc" and on_child.children[0].children[1].type.to_s == "symbol_literal"
					on_method = get_left_most_leaf(on_child.children[0].children[1]).source.to_s
					if on_method == "create"
						temp_method = nil
						if $cur_class.getMethod("new") == nil
							temp_method = Method_class.new("new")
						else
							temp_method = $cur_class.getMethod("new")
						end
						method_list.each do |each_method|
							fcall = Function_call.new("self", each_method)
							temp_method.getCalls.push(fcall)
						end
						$cur_class.addMethod(temp_method)
					end
				end
			end
			
			#before validation is called for every valid?
			temp_method = Method_class.new("valid?")
			method_list.each do |each_method|
				fcall = Function_call.new("self", each_method)
				temp_method.getCalls.push(fcall)
			end
			$cur_class.addMethod(temp_method)
			if block_child != nil
				$cur_method = temp_method
			end
			
		when "after_create","before_create"
			temp_method = nil
			if $cur_class.getMethod("new") == nil
				temp_method = Method_class.new("new")
			else
				temp_method = $cur_class.getMethod("new")
			end
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						fcall = Function_call.new("self", get_left_most_leaf(child).source.to_s)
						temp_method.getCalls.push(fcall)
					end
				end
			end
			#Class_class.@method is a hash map, so add == set+insert 
			$cur_class.addMethod(temp_method)
		when "after_save","before_save"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						fcall = Function_call.new("self", get_left_most_leaf(child).source.to_s)
						$cur_class.addSave(fcall)
					end
				end
			end
		#else
	end
end

#parse assignment, put the assigned value into method's variable list
def parse_assign(astnode, method)
	@node = astnode.children[0]
	#while @node.children.length != 0 do
	#	@node = @node.children[0]
	#end		
	method.getVars[@node.source.to_s] = astnode.source
	return @node.source.to_s
end

#parse method call, check if it is query related
def parse_method_call(astnode, method)
	@node = astnode
	#while @node.children.length != 0 do
	#	@node = @node.children[0]
	#end
	@node = astnode.children[0]
	#function call: caller.func(params)
	if method != nil and astnode.children[1] != nil and astnode.children[1].type.to_s == "ident"

		@node2 = astnode.children[1]
		fcall = Function_call.new(@node.source.tr("\n",""), @node2.source)
		#if @node.type.to_s == "const" and check_table_name(@node.source.to_s)
		if check_method_keyword(@node2.source) then
			fcall.setTableName(searchSelf(fcall.getObjName, $cur_class.getName))
			fcall.setIsQuery
			fcall.setQueryType(check_method_keyword(@node2.source))

			if @node2.source == "execute"
				query = astnode.children[2].source
				if query.include?("UPDATE")
					fcall.setQueryType("UPDATE")
				elsif query.include?("SELECT")
					fcall.setQueryType("SELECT")
				elsif query.include?("INSERT")
					fcall.setQueryType("INSERT")
				end
			end
			#	puts "++ CALL DB Queries: #{@node.source} . #{@node2.source}"
			#	translate_query(@node, @node2, astnode)
		end
		#end
		if astnode.children[2] != nil and astnode.children[2].type.to_s == "arg_paren"
			fcall.parseParams(astnode.children[2].children[0])
		end	
		method.getCalls.push(fcall)
		$cur_funccall = fcall
	
	elsif $cur_method != nil and astnode.children[0].type.to_s == "ident"
		fcall = Function_call.new("self", astnode.children[0].source)
		method.getCalls.push(fcall)
		$cur_funccall = fcall
	elsif astnode.type.to_s == "command"
		parse_attrib(astnode)
		$cur_funccall  = nil
	else
		$cur_funccall = nil
	end
	return $cur_funccall
end

