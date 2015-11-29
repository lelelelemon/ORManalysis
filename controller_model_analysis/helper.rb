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

def is_transaction_function(fname)
	if ["transaction_begin","transaction_end"].include?(fname)
		return true
	else
		return false
	end
end

def is_repeatable_function(fname)
	if is_transaction_function(fname)
		return true
	else
		return false
	end
end

def in_key_words(w)
	if ["before_filter", "before_save", "before_validation",
			"before_create",
			"after_save", "after_validation", "after_create"].include?(w)
		return true
	else
		return false
	end
end

def searchTableName(name)
	_name = name
	if name.index('.') != nil
		_name = name[0..(name.index('.')-1)]
	end
	if $table_names.include?(_name)
		return _name
	end
	return nil
end
def searchSelf(name, class_name)
	if name.index('.') != nil and name[0..(name.index('.')-1)] == "self"
		return class_name
	end
	if name == "self"
		return class_name
	end
	return nil
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

def check_method_keyword(k)
	return $key_words[k]
end

def trigger_save?(call)
	if ["INSERT", "UPDATE"].include?call.getQueryType	
		return true
	end
	if ["save", "save!"].include?call.getFuncName
		return true
	end
	return false
end

def trigger_create?(call)
	if ["INSERT"].include?call.getQueryType	
		return true
	end
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

def get_mvc_name2(filename)
	i = filename.rindex('/')
	j = filename.rindex('.')
	n = filename[i+1..j-1]
	n[0] = n[0].upcase
	if n.include?('_')
		k = n.index('_')
		n[k+1] = n[k+1].upcase
		n = n.delete('_')
	end
	return n
end

def remove_module_info(name)
	i = name.rindex(':')
	n = name[i+1..name.length-1]
	return n
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

def get_class_list(astnode, class_list)
	if astnode.type.to_s == "class" or astnode.type.to_s == "module"
		class_list.push(astnode)
	end
	astnode.children.each do |child|
		get_class_list(child, class_list)
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

def call_match_name(caller_name, funcname, f_handler)
	f_handler.getCalls.each do |call|
		if call.getObjName.include?(caller_name) and funcname == call.getFuncName
				return call 
		end
	end
	return nil
end

#Graphviz doesn't recognize special characters
def simplify(name)
	n = name.delete('!').delete('?')
	return n
end

def simplify1(name)
	return name.tr(".","_")
end
