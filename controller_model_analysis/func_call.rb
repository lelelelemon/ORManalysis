#class Function_param
#class Function_call
#class Method_vars

class Function_param
	def initialize(assign_str)
		@var_name = ""
		@p_string = assign_str
		@param_name = ""
		#source can be either a string #"FRONTEND"
		#or a variable handler
		@source = nil
	end
	def setSource(src)
		@source = src
	end
	def setVarName(vname)
		@var_name = vname
	end
	def setParamName(pname)
		@param_name = pname
	end
	def getVar
		@var_name
	end
	def getParam
		@param_name
	end
	def getString
		@p_string
	end
end

class Function_call
	def initialize(obj, funcname)
		@obj_name = obj
		@func_name = funcname
		@is_query = false
		@query_type = ""
		@table_name = nil
		@params = Array.new
		@returnv = ""
	end
	def setQueryType(type)
		@query_type = type
	end
	def getQueryType
		@query_type
	end
	def getTableName
		@table_name
	end
	def setReturnValue(rv)
		@returnv = rv
	end
	def getReturnValue
		@returnv
	end
	def setIsQuery
		@is_query = true
		if searchTableName(@obj_name) != nil
			@table_name = searchTableName(@obj_name)
		end
	end
	def setTableName(tbl_name)
		@table_name = tbl_name
	end
	def isQuery
		@is_query
	end
	def getParams
		@params
	end
	def getObjName
		@obj_name
	end
	def getFuncName
		@func_name
	end
	#TODO: this is a trick that we shouldn't use... 
	#user.where(...)
	#We search sting match: user -> User
	#then assume user's type is User
	def findNonRecordedCaller
		caller_class = transform_var_name(@obj_name)
		#if caller_class != nil
		#	puts "\t\t-- find Non Recorded caller: #{@obj_name}.class = #{caller_class}"
		#end
		return caller_class
	end
	#For example:
	#class C
	#	def foo(p)
	#  puts "FOO: #{p}"
	# end
	#end
	#class A
	# def meth
	#		c.foo(1)
	# end
	#end
	#
	# @obj_name = c
	# @func_name = foo
	#findCaller(A, meth) returns C
	def findCaller(calling_func_class, calling_func)
		caller_class = nil
		if @is_query == false
			if @obj_name == "self" 
				caller_class = calling_func_class
				if $class_map[caller_class].getMethod(@func_name) == nil
					caller_class = $class_map[calling_func_class].getUpperClass
					#TODO: I hate this, but exception handler should anyway appear somewhere...
					if $class_map[caller_class] == nil
						caller_class = nil
					end
				end
			end
			#Luckily, the log records the type of c
			if $class_map[calling_func_class].getMethodVarMap.has_key?(calling_func)
				func_var = $class_map[calling_func_class].getMethodVarMap[calling_func].get_var_map
				if func_var != nil and func_var.has_key?(@obj_name)
					caller_class = func_var[@obj_name]
				end
			end
			#TODO: Have no idea why I search derived class??
			if caller_class == nil
			#	derived_classes = search_derived_class($class_map[calling_func_class])
			#	derived_classes.each do |derived_class|
			#		if derived_class.getMethodVarMap.has_key?(calling_func)
			#			func_var = derived_class.getMethodVarMap[calling_func].get_var_map
			#			if func_var != nil and func_var.has_key?(@obj_name)
			#				caller_class = func_var[@obj_name]
			#				break
			#			end
			#		end
			#	end
			end
			if caller_class == nil
				caller_class = findNonRecordedCaller
			end
			#still obj_name brutal match, deleting special characters
			if caller_class == nil
				simplified_obj_name = @obj_name.delete('@').delete('$')
				if $class_map[simplified_obj_name] != nil
						caller_class = simplified_obj_name
				else
					$class_map.each do |cc, cv|
						if cc.downcase==simplified_obj_name.downcase
							caller_class = cc
						end
						if cc.include?("::") and caller_class == nil
							c_list = cc.split("::")
							c_list.each do |cc1|
								if cc1.downcase == simplified_obj_name.downcase
									caller_class = cc
								end
							end
						end
					end
				end
				#if $class_map[@obj_name.delete('@').delete('$')] != nil
				#	caller_class = @obj_name
				#end
			end
			#Rails specific, method can be defined in scope
			if caller_class == nil
				if @obj_name.include?("scope") and $class_map[calling_func_class] != nil and $class_map[calling_func_class].getMethods.find(@func_name) != nil
					caller_class = calling_func_class
				end
			end
			if caller_class == nil
				caller_class = search_distinct_func_name(@func_name)
			end
			#puts "#{calling_func_class}.#{calling_func} issues call #{@obj_name} [of class #{caller_class}] . #{@func_name}"
			#puts ""
		end	
		return caller_class
	end

	#when calling this function, the func_call handler hasn't been set up yet, so we delay figuring out the source of variables being passed
	def parseParams(astnode)
		if astnode.children[0].type.to_s == "list"
			return parseParams(astnode.children[0])
		end
		astnode.children.each do |param|
			new_param = Function_param.new(param.source.to_s)
			if is_ast_node(param) and param.type.to_s == "assoc"
				field = get_left_most_leaf(param).source.to_s
				assoc_node = param
				#field = get_left_most_leaf(param.children[0]).source.to_s
				#assoc_node = param.children[0]
				new_param.setParamName(field)
				if is_ast_node(assoc_node.children[1]) and ["aref","call"].include?assoc_node.children[1].type.to_s
					aref_node = searchARef(assoc_node.children[1])
					lmost = get_left_most_leaf(assoc_node.children[1])
					if ["params","cookies","session"].include?lmost.source.to_s
						new_param.setVarName(aref_node.source.to_s)
						new_param.setSource("FRONTEND")
					else
						var_ref = searchVarRef(assoc_node.children[1])
						if var_ref != nil
							new_param.setVarName(var_ref.source.to_s)
						end
					end
				else 
					var_ref = searchVarRef(assoc_node.children[1])
					if var_ref != nil
						new_param.setVarName(var_ref.source.to_s)
					end
				end
			elsif is_ast_node(param) and param.type.to_s == "aref"
				lmost = get_left_most_leaf(param)
				if ["params","cookes","session"].include?lmost.source.to_s
						new_param.setVarName(param.source.to_s)
						new_param.setSource("FRONTEND")
				end
			elsif param.type.to_s == "symbol_literal"
				field = param.children[0].source.to_s
				new_param.setParamName(field)
			else
				var_ref = searchVarRef(param)
				if var_ref != nil
					new_param.setVarName(var_ref.source.to_s)	
				end
			end
			@params.push(new_param)
		end
	end

	def print
		temp_params = ""
		@params.each do |param|
			temp_params += "#{param.getVar}, "
		end
		if @is_query
			puts "++ CALL DB QUERY: #{@obj_name} . #{@func_name} (params: #{temp_params}, returnv: #{@returnv})"
		else
			puts "#{@obj_name} . #{@func_name} (params: #{temp_params}, returnv: #{@returnv})"
		end
	end
end

class Method_vars
	def initialize(f_name)
		@var_map = Hash.new
		@name = f_name
	end
	def get_name
		@name
	end
	def insert_var(v_name, v_class)
		if @var_map.has_key?(v_name) == false
			@var_map[v_name] = v_class
		end
	end	
	def search_var(v_name)
		if @var_map.has_key?(v_name)
			return @var_map[v_name]
		else
			return nil
		end
	end
	def get_var_map
		@var_map
	end
end

