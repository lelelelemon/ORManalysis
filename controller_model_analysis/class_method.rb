#load "func_call.rb"

class Method_class
	def initialize(name)
		@variables = Hash.new
		@name = name
		@calls = Array.new
		@cfg = nil
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
end

class Class_class
	def initialize(name)
		@methods = Hash.new
		@name = name
		@belongs_to = Array.new
		@variable = Array.new
		@upper_class = nil
		@upper_class_instance = nil
		@method_var_map = Hash.new
		@before_filter = Array.new
		@save_actions = Array.new
		@create_actions = Array.new
		@scope_list = Array.new
		@fields = Array.new
		
		filter_meth = Method_class.new("before_filter")
		@methods[filter_meth.getName] = filter_meth
		save_meth = Method_class.new("before_save")
		@methods[save_meth.getName] = save_meth
		valid_meth = Method_class.new("before_validation")
		@methods[valid_meth.getName] = valid_meth
		create_meth = Method_class.new("before_create")
		@methods[create_meth.getName] = create_meth
		#If there is keyword "only":
		#Final pass, remove from "before_xxx" list and insert into the function
		#If there is keyword "on":
		#Remove from original list and insert into according list
		#@after_create = Array.new
		#@after_destroy = Array.new
	end
	def getFields
		@fields
	end
	def addField(t_field)
		@fields.push(t_field)
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
	end
	def getMethod(name)
		@methods[name]
	end
	def getMethod(meth_name)
		@methods[meth_name]
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
		
	def addBeforeFilter(filter_name)
		@before_filter.push(filter_name)
	end
	def getBeforeFilter
		@before_filter
	end
	def mergeBeforeFilter(c)
		if c.getMethod("before_filter") != nil
			if @methods["before_filter"] == nil
				@methods["before_filter"] = c.getMethod("before_filter")
			else
				c.getMethod("before_filter").getCalls.each do |call|
					exist = false
					@methods["before_filter"].getCalls.each do |inner_call|
						if inner_call.getFuncName == call.getFuncName
							exist = true
						end
					end
					if exist == false
						@methods["before_filter"].getCalls.insert(0, call)
					end
				end
			end
		end
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

