def parse_attrib_node(astnode)
#TODO: currently only handles single attribute node
	return get_left_most_leaf(astnode).source.to_s
end

def find_property(node, keyword)
	if node == nil
		return nil
	end
	if node.source.include?(keyword)
		return node
	end
	node.children.each do |child|
		n = find_property(child, keyword)
		if n != nil
			return n
		end
	end
	return nil
end

def addOnList(list, node)
	node.children.each do |c|
		if c.type.to_s == "assoc"
			#the first child is "only" or "on"
			if c.children[1].type.to_s == "list" or c.children[1].type.to_s == "binary"
				c.children[1].children.each do |e|
					f_name = get_left_most_leaf(e).source.to_s
					list.push(f_name)
				end
			elsif c.children[1].type.to_s == "array"
				if c.children[1].children[0].type.to_s == "list"
					c.children[1].children[0].children.each do |e|
						f_name = get_left_most_leaf(e).source.to_s
						list.push(f_name)
					end
				end
			elsif c.children[1].type.to_s == "symbol_literal"
				f_name = get_left_most_leaf(c.children[1]).source.to_s
				list.push(f_name)
			end
		end
	end
end

def parse_keyword(astnode, meth)
	#process block
	block_child = nil
	astnode.children.each do |child|
		if child.type.to_s == "do_block"
			block_child = child
		end
	end
	if block_child != nil
		temp_method = Method_class.new("#{meth.getName}_do_block")
		$cur_method = temp_method
		fcall = Function_call.new("self", temp_method.getName)
		meth.addCall(fcall)
	end
	on_list = Array.new
	cond_list = Array.new
	fcall_list = Array.new
	if astnode.children[1].type.to_s == "list"
		astnode.children[1].children.each do |child|
			if child.type.to_s == "symbol_literal"
				#$cur_class.addBeforeFilter(get_left_most_leaf(child).source.to_s)
				
				fcall = Function_call.new("self", get_left_most_leaf(child).source.to_s)
				fcall_list.push(fcall)
				#puts "#{$cur_class.getName} add before filter: #{get_left_most_leaf(child).source.to_s}"
			elsif child.source.to_s.include?(":only") or child.source.to_s.include?(":on")
				addOnList(on_list, child)
				#print "#{$cur_class.getName} . (#{meth.getName}). on_list: "
				#on_list.each do |o|
				#	print "#{o}, "
				#end
				#puts ""
			elsif child.source.to_s.include?(":unless") or child.source.to_s.include?(":if")
				addOnList(cond_list, child)
			end
		end
	end
	cond_list.each do |c|
		fcall = Function_call.new("self", c)
		fcall_list.push(fcall)
	end
	if on_list.length > 0
		fcall_list.each do |f|
			on_list.each do |o|
				f.addOn(o)
			end
		end
	end
	fcall_list.each do |f|
		meth.addCall(f)
		#puts "\t#{f.getFuncName}"
	end
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
		when "scope"
			scope_func_list = Array.new
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						scope_func_list.push(get_left_most_leaf(child).source.to_s)
						$cur_class.addScope(get_left_most_leaf(child).source.to_s)
					elsif child.type.to_s == "lambda" and scope_func_list.length > 0
						$cur_method = Method_class.new(scope_func_list[-1])
						$cur_class.addMethod($cur_method)
						traverse_ast(child, 3)
						$cur_method = nil
					elsif child.type.to_s == "fcall" and scope_func_list.length > 0		
						$cur_method = Method_class.new(scope_func_list[-1])
						$cur_class.addMethod($cur_method)
						child.children.each do |c1|
							traverse_ast(c1, 3)
						end
						$cur_method = nil
					end
				end
			end
		when "attr_accessor"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					if child.type.to_s == "symbol_literal"
						$cur_class.addVariable(get_left_most_leaf(child).source.to_s)
					end
				end
			end
		when "before_filter","before_action"
			parse_keyword(astnode, $cur_class.getMethod("before_filter"))
		when "before_validation"
			parse_keyword(astnode, $cur_class.getMethod("before_validation"))
		when "after_create","before_create"
			parse_keyword(astnode, $cur_class.getMethod("before_create"))
		when "after_save","before_save"
			parse_keyword(astnode, $cur_class.getMethod("before_save"))
		#else
	end

	if astnode.children[0].source.to_s.include?"validates"
		parse_keyword(astnode, $cur_class.getMethod("before_validation"))
		if ["validates_uniqueness_of", "validates_presence_of"].include?astnode.children[0].source.to_s
			if $cur_class.getMethod("before_validation").hasCall?("self", "where") == false
				fcall = Function_call.new("self", "where")
				fcall.setIsQuery
				fcall.setTableName($cur_class.getName)
				fcall.setQueryType("SELECT")
				$cur_class.getMethod("before_validation").addCall(fcall)
			end
		end
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
	#if astnode.children[1]!= nil and astnode.children[1].source.to_s == "find_or_create_key_for_update"
	#	puts "@ @ @ @ @ @ @"
	#end
	#function call: caller.func(params)
	cond1 = (astnode.children[1] != nil and astnode.children[1].type.to_s == "ident")
	#function call: func(param)
	cond2 = (astnode.type.to_s != "command" and astnode.children[0].type.to_s == "ident")
	if method != nil and (cond1 or cond2)
	
		fcall = nil
		node2 = nil
		if cond1
			node2 = astnode.children[1]
			fcall = Function_call.new(@node.source.tr("\n",""), node2.source)
		elsif cond2
			node2 = astnode.children[0]
			fcall = Function_call.new("self", node2.source)
		end
		#if @node.type.to_s == "const" and check_table_name(@node.source.to_s)
		if check_method_keyword(node2.source) then
			fcall.setTableName(searchSelf(fcall.getObjName, $cur_class.getName))
			fcall.setIsQuery
			fcall.setQueryType(check_method_keyword(node2.source))

			if node2.source == "execute"
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

	elsif astnode.type.to_s == "command" or (astnode.children[0].type.to_s == "ident" and in_key_words(astnode.children[0].source.to_s))
		parse_attrib(astnode)
		$cur_funccall  = nil
	else
		$cur_funccall = nil
	end
	return $cur_funccall
end

