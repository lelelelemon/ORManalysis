def transform_controller_name(name)
	i = name.index("Controller")
	new_name = "#{(name[0...i-1]).downcase}_controller"
	return new_name
end

def is_ast_node(node)
	if node != nil and node.class.to_s == "YARD::Parser::Ruby::AstNode"
		return true
	elsif node != nil
		return node.class.ancestors.include?YARD::Parser::Ruby::AstNode
	else
		return false
	end
end

def searchVarRef(node)
	if is_ast_node(node)==false
		return nil
	end
	if node.type.to_s == "var_ref"
		return node
	end
	if node.children[0] != nil
		node.children.each do |child| 
			v = searchVarRef(child)
			if v != nil
				return v
			end
		end
	else
		return nil
	end
	return nil
end

def searchARef(node)
	if is_ast_node(node)==false
		reutnr nil
	end
	if node.type.to_s == "aref"
		return node
	end
	if node.children[0] != nil
		node.children.each do |child| 
			v = searchARef(child)
			if v != nil
				return v
			end
		end
	else
		return nil
	end
	return nil
end

#read variable class list
def check_class_match(name)
	if $class_map.has_key?(name)
		return true
	end
	return false
end

def transform_var_name(name)
	$class_map.each do |keyc, arrayc|
		cname = name
		if name[0] == '@'
			cname = name[1..name.length-1]
			#puts "After truncate, #{name} -> #{cname}"
		end
		if keyc.downcase == cname.downcase
			return keyc
		end
	end
	#$class_map.each do |keyc, arrayc|
	#	if keyc.include?("Controller")==false and keyc.downcase.include?(cname.downcase)
	#		return keyc
	#	end
	#end	
	return nil
end

#parse specific node
def get_left_most_leaf(node)
	rv = node	
	while is_ast_node(rv) do
		if rv.children.length > 0
			rv = rv.children[0]
		else
			break
		end
	end
	return rv
end

def get_mvc_name(filename)
	i = filename.rindex('/')
	j = filename.rindex('.')
	n = filename[i+1..j-1]
	return n
end

def set_class(ast, is_controller)
	class_node = get_class_node(ast)
	class_name = get_left_most_leaf(class_node).source.to_s
	if is_controller
		$cur_class = Controller_class.new(class_name)
	else
		$cur_class = Model_class.new(class_name)
	end
	if class_node.children[1].type.to_s == "const_path_ref" or ast.children[0].children[1].type.to_s  == "var_ref"
		$cur_class.setUpperClass(class_node.children[1].source.to_s)
		#puts "class #{class_name} < #{$cur_class.getUpperClass}"
	end
	$class_map[class_name] = $cur_class
end

def set_class_with_template(ast, is_controller)
	module_node = get_module_node(ast)
	class_node = get_class_node(ast)
	module_name = get_left_most_leaf(module_node).source.to_s
	class_name = get_left_most_leaf(class_node).source.to_s
	if is_controller
		$cur_class = Controller_class.new("#{module_name}::#{class_name}")
	else
		$cur_class = Model_class.new("#{module_name}::#{class_name}")
	end
	if class_node.children[1].type.to_s == "const_path_ref" or class_node.children[1].type.to_s  == "var_ref"
		$cur_class.setUpperClass(class_node.children[1].source.to_s)
		#puts "class #{class_name} < #{$cur_class.getUpperClass}"
	end
	$class_map["#{module_name}::#{class_name}"] = $cur_class
end

def get_module_node(astnode)
	if astnode.type.to_s == "module"
		return astnode
	end
	astnode.children.each do |child|
		n = get_module_node(child)
		if n != nil
			return n
		end
	end
	return nil
end

def get_class_node(astnode)
	if astnode.type.to_s == "class"
		return astnode
	else
		astnode.children.each do |child|
			n = get_class_node(child)
			if n != nil
				return n
			end
		end
		return nil
	end
end

def search_distinct_func_name(func_name)
	count = 0
	class_name = ""
	$class_map.each do |keyc, valuec|
		if valuec.getMethods[func_name] != nil
			class_name = keyc
			count += 1
		end
	end
	if count == 1
		return class_name
	else
		return nil
	end
end
