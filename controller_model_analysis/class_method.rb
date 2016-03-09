#load "func_call.rb"

class Method_class
	def initialize(name)
		@variables = Hash.new
		@name = name
		@calls = Array.new
		@cfg = nil
		@caller_class = nil
		#only for before_xxx calls
	end
	def getVars
		@variables
	end
	def getName
		@name
	end
	def getCalls
		@calls
	end
	def addCall(c)
		if @calls.include?(c) == false
			@calls.push(c)
		end
	end
	def hasCall?(objn, fcname)
		@calls.each do |c|
			if c.getObjName == objn and c.getFuncName == fcname
				return true
			end
		end
		return false
	end
	def setCFG(cfg)
		@cfg = cfg
		cfg.setMHandler(self)
	end
	def getCFG
		@cfg
	end
	def getCallerClass
		@caller_class
	end
	def setCallerClass(c)
		@caller_class = c
	end
end

class Assoc_attrib
	def initialize(_name)
		@name = _name
		@attribs = Hash.new
	end
	attr_accessor :name, :attribs
end

class Class_class
	def initialize(name)
		@methods = Hash.new
		@name = name
		@belongs_to = Array.new
		@variable = Array.new
		@upper_class = nil
		@upper_class_instance = nil
		@include_module = Array.new
		@method_var_map = Hash.new
		@before_filter = Array.new
		@save_actions = Array.new
		@create_actions = Array.new
		@scope_list = Array.new
		#table_fields is a list of Table_field
		@table_fields = Array.new
		#class_fields is actually a super set of table_fields
		#but class_fields is a list of string
		#XXX: If the class field is not explicitly defined, we don't deal with it
		@class_fields = Array.new
		@assocs = Hash.new
		@var_map = Hash.new	
	
		filter_meth = Method_class.new("before_filter")
		addMethod(filter_meth)
		save_meth = Method_class.new("before_save")
		addMethod(save_meth)
		valid_meth = Method_class.new("before_validation")
		addMethod(valid_meth)
		create_meth = Method_class.new("before_create")
		addMethod(create_meth)
		#If there is keyword "only":
		#Final pass, remove from "before_xxx" list and insert into the function
		#If there is keyword "on":
		#Remove from original list and insert into according list
		#@after_create = Array.new
		#@after_destroy = Array.new
	end
	attr_accessor :include_module, :filename
	def getAssocs
		@assocs
	end
	def getAssoc(_name)
		@assocs[_name]
	end
	def addAssoc(_name, assoc)
		if @assocs[_name] == nil
			@assocs[_name] = Array.new
		end
		@assocs[_name].push(assoc)
		#if assoc.attribs.has_key?("foreign_key")
		#	@class_fields.push(assoc.attribs["foreign_key"])
		#end
		@class_fields.push(assoc.name)
	end
	def searchAssocForRelation(fieldname)
	#for example, if self.name == "Comment" and 
	#class Comment
	#  belongs_to: user
	#then self.searchAssoc("user") -> belongs_to
		@assocs.each do |k, v|
			v.each do |a|
				if a.name == fieldname
					return k
				end
			end
		end
		return nil
	end
	def searchAssocForClass(fieldname)
	#for example, if self.name == "Comment" and 
	#class Comment
	#  belongs_to: user, :class_name = "User"
	#then self.searchAssoc("user") -> "User"
		@assocs.each do |k, v|
			v.each do |a|
				if a.name == fieldname
					return a.attribs["class_name"]
				end
			end
		end
		return nil
	end

	def getTableFields
		@table_fields
	end
	def addTableField(t_field)
		@table_fields.push(t_field)
		addClassField(t_field.field_name)
	end
	def addClassField(c_field)
		if @class_fields.include?(c_field)
		else
			@class_fields.push(c_field)
		end
	end
	def getClassFields
		@class_fields
	end
	def getName
		@name
	end
	def setUpperClass(up_name)
		@upper_class = up_name
	end
	def setUpperClassInstance(upper_class)
		@upper_class_instance = upper_class
	end
	def getUpperClass
		@upper_class
	end
	def getUpperClassInstance
		@upper_class_instance
	end
	def getMethods
		@methods
	end
	def addMethod(meth)
		@methods[meth.getName] = meth
		meth.setCallerClass(self)
	end
	def getMethod(name)
		@methods[name]
	end
	#findMethod traces up to parent class
	#Actually the logic here is just like "findCaller" in Function_call
	#TODO: here we use depth... to force stop searching
	def findMethodRecursive(name, step = 0)
		if @methods[name]
			return @methods[name]
		else
			#TODO: Name change.... actually library?
			if name == "to_json"
				name = "as_json"
			end
			if step > 5
				return nil
			end
			temp_class_name = @upper_class
			@searched_class = Array.new
			@step = 0
			while $class_map[temp_class_name] != nil and @step < 10
				@step += 1
				f = $class_map[temp_class_name].findMethodRecursive(name, step+1)
				if f != nil
					return f
				else
					temp_class_name = $class_map[temp_class_name].getUpperClass
				end
			end
			@include_module.each do |inc|
				if $class_map[inc] != nil
					f = $class_map[inc].findMethodRecursive(name, step+1)
					if f != nil
						return f
					end
				end
			end
			if cname = search_distinct_func_name(name)
				return $class_map[cname].getMethod(name)
			end
			return nil
		end
	end
	def addBelongsTo(belong_name)
		@belongs_to.push(belong_name)
	end
	def addVariable(var_name)
		@variable.push(var_name)
	end
	def addSave(func)
		@save_actions.push(func)
	end
	def getSave
		@save_actions
	end
	def mergeSave(c)
		c.getSave.each do |s|
			if @save_actions.include?(s)==false
				@save_actions.push(s)
			end
		end
		self.mergeValidation(c, "before_save")
	end
	def addCreate(func)
		@create_actions.push(func)
	end
	def getCreate
		@create_actions
	end
	def mergeCreate(c)
		c.getCreate.each do |cr|	
			if @create_actions.include?(cr)==false
				@create_actions.push(cr)
			end
		end
		self.mergeValidation(c, "before_create")
	end
	def addScope(s)
		@scope_list.push(s)
	end
	def getScope
		@scope_list
	end

	#A pass that adjust filter calls, for keywords only, on
	def adjustSingleFilter(filter_name)
		meth = @methods[filter_name]
		remove_list = Array.new
		meth.getCalls.each do |c|
			if c.getOn.length > 0
				c.getOn.each do |on|
					if @methods[on] == nil
						puts "Defined #{filter_name} :on => #{on}, but method #{on} is not explicitly defined"
					else
						@methods[on].insertCall(c)
					end
				end
				remove_list.push(c)
			end
		end
		remove_list.each do |r|
			meth.getCalls.delete(r)
		end
	end
	def adjustFilters
		adjustSingleFilter("before_filter")
	end
	#def addBeforeValidation(valid_name)
	#	@before_validation.push(valid_name)
	#end

	#TODO: to be deprecated!!!	
	#mappings of function name ane variable type list
	def addMethodVar(func_name, var_name, class_name)
		if @method_var_map.has_key?(func_name)
			@method_var_map[func_name].insert_var(var_name, class_name)
		else
			temp_f = Method_vars.new(func_name)
			temp_f.insert_var(var_name, class_name)
			@method_var_map[func_name] = temp_f
		end
	end
	def getMethodVarMap
		@method_var_map
	end

	#The following is defined in type inferece!
	def getVarMap
		@var_map
	end
	def addToVarMap(v_name, var)
		@var_map[v_name] = var
	end

		
	def addBeforeFilter(filter_name)
		@before_filter.push(filter_name)
	end
	def getBeforeFilter
		@before_filter
	end
	def mergeValidation(c, validation_name)
		if c.getMethod(validation_name) != nil
			if @methods[validation_name] == nil
				@methods[validation_name] = c.getMethod(validation_name)
			else
				c.getMethod(validation_name).getCalls.each do |call|
					exist = false
					@methods[validation_name].getCalls.each do |inner_call|
						if inner_call.getFuncName == call.getFuncName
							exist = true
						end
					end
					if exist == false
						@methods[validation_name].getCalls.insert(0, call)
					end
				end
			end
		end
	end
	def mergeBeforeFilter(c)
		self.mergeValidation(c, "before_filter")
	end
	def print_var_types
		puts "######## BEGIN ########"
		puts "Class: #{@name}"
		@method_var_map.each do |key2, value2|
			print "function #{value2.get_name} : "
			value2.get_var_map.each do |key3, value3|
				print "#{key3}(#{value3}), "
			end
			puts ""
			puts "----"
		end
		puts "###### END #######"
		puts ""
	end
	def print_calls
		puts "######## BEGIN ########"
		puts "Class: #{@name}"
		
		@methods.each do |key, array|
			puts "Method #{key}:\n"
			print "\t ** variables: {"
			array.getVars.each do |key2, array2|
				print "#{key2}, "
			end
			puts "}"
			array.getCalls.each do |each_call|
				print "\t "
				each_call.print
			end
		end
	end

	def print_instructions
		@methods.each do |key, array|
			puts "SET METHOD: name = #{key}"
			if array.getCFG != nil
				array.getCFG.getBB.each do |bb|
					bb.self_print
				end
			end
		end
	end
end

class Model_class < Class_class
	def initialize(name)
		super(name)
		@has_one = Array.new
		@has_many = Array.new
	end
	def addHasOne(hasone_name)
		@has_one.push(hasone_name)
	end
	def addHasMany(hasmany_name)
		@has_many.push(hasmany_name)
	end
end

class Controller_class < Class_class
	def initialize(name)
		super(name)
	end
end

