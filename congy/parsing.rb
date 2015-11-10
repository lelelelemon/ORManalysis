require 'yard'
require 'logger'
require 'optparse'

PATH_ORDER = [
  'lib/yard/autoload.rb',
  'lib/yard/code_objects/base.rb',
  'lib/yard/code_objects/namespace_object.rb',
  'lib/yard/handlers/base.rb',
  'lib/yard/generators/helpers/*.rb',
  'lib/yard/generators/base.rb',
  'lib/yard/generators/method_listing_generator.rb',
  'lib/yard/serializers/base.rb',
  'lib/**/*.rb'
]

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
		@params = Array.new
		@returnv = ""
	end
	def setReturnValue(rv)
		@returnv = rv
	end
	def getReturnValue
		@returnv
	end
	def setIsQuery
		@is_query = true
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
	def findNonRecordedCaller
		caller_class = transform_var_name(@obj_name)
		#if caller_class != nil
		#	puts "\t\t-- find Non Recorded caller: #{@obj_name}.class = #{caller_class}"
		#end
		return caller_class
	end
	def findCaller(calling_func_class, calling_func)
		caller_class = nil
		if @is_query == false
			if @obj_name == "self"
				caller_class = calling_func_class
			end
			if $class_map[calling_func_class].getFuncVarMap.has_key?(calling_func)
				func_var = $class_map[calling_func_class].getFuncVarMap[calling_func].get_var_map
				if func_var != nil and func_var.has_key?(@obj_name)
					caller_class = func_var[@obj_name]
				end
			end
			if caller_class == nil
				derived_classes = search_derived_class($class_map[calling_func_class])
				derived_classes.each do |derived_class|
					if derived_class.getFuncVarMap.has_key?(calling_func)
						func_var = derived_class.getFuncVarMap[calling_func].get_var_map
						if func_var != nil and func_var.has_key?(@obj_name)
							caller_class = func_var[@obj_name]
							break
						end
					end
				end
			end
			if caller_class == nil
				caller_class = findNonRecordedCaller
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
		if @is_query
			puts "++ CALL DB QUERY: #{@obj_name} . #{@func_name}"
		else
			puts "#{@obj_name} . #{@func_name}"
		end
	end
end

$cur_funccall = nil
$cur_position = ""

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

class Method_class
	def initialize(name)
		@variables = Hash.new
		@name = name
		@calls = Array.new
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
end
#$method_map = Hash.new
$cur_method = Method_class.new("empty_class")

class Class_class
	def initialize(name)
		@methods = Hash.new
		@name = name
		@belongs_to = Array.new
		@variable = Array.new
		@upper_class = ""
		@upper_class_instance = nil
		@func_var_map = Hash.new
		@before_filter = Array.new
		#@after_create = Array.new
		#@after_destroy = Array.new
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
	def getMethod(meth_name)
		@methods[meth_name]
	end
	def addBelongsTo(belong_name)
		@belongs_to.push(belong_name)
	end
	def addVariable(var_name)
		@variable.push(var_name)
	end
	#def addBeforeValidation(valid_name)
	#	@before_validation.push(valid_name)
	#end
	
	#mappings of function name ane variable type list
	def addFuncVar(func_name, var_name, class_name)
		if @func_var_map.has_key?(func_name)
			@func_var_map[func_name].insert_var(var_name, class_name)
		else
			temp_f = Function_vars.new(func_name)
			temp_f.insert_var(var_name, class_name)
			@func_var_map[func_name] = temp_f
		end
	end
	def getFuncVarMap
		@func_var_map
	end
		
	def addBeforeFilter(filter_name)
		@before_filter.push(filter_name)
	end
	def getBeforeFilter
		@before_filter
	end
	def print_var_types
		puts "######## BEGIN ########"
		puts "Class: #{@name}"
		@func_var_map.each do |key2, value2|
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
end
$cur_class = Class_class.new("empty_class")
$class_map = Hash.new

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


#read table name list 
$table_names = Array.new
file_table = File.open("table_name.txt")
file_table.each do |line|
	$table_names = $table_names.push(line.chomp)
end
def check_table_name(varname)
	if $table_names.include?(varname) then
		return true
	else
		return false
	end
end
#puts "Tables = #{$table_names}"

#read keywords list
$key_words = Array.new
File.open("keywords.txt").each do |line|
	$key_words = $key_words.push(line.chomp)
end
def check_method_keyword(varname)
	if $key_words.include?(varname) then
		return true
	else
		return false
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

class Function_vars
	def initialize(f_name)
		@var_map = Hash.new
		@name = f_name
	end
	def get_name
		@name
	end
	def insert_var(v_name, v_class)
		@var_map[v_name] = v_class
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

def read_dynamic_typing_info
	Dir.glob('/home/congy/ruby_source/yard/benchmarks/logs/*.log') do |item|
		next if item == '.' or item == '..'
		class_name = get_mvc_name(item)
		if $class_map.has_key?(class_name) == false
			abort("Class #{class_name} (#{item}) cannot be found!")
		end
		class_handler = $class_map[class_name]
		file = File.open(item, "r")
		file.each_line do |line|
			c_array = line.split(": ")
			func_name = c_array[0].chomp
			if c_array.length > 1
				var_name = c_array[1].split(" -> ")[0].chomp
				class_name = c_array[1].split(" -> ")[1].chomp
				class_handler.addFuncVar(func_name, var_name, class_name)	
			#elsif
			#	puts "FUNCTION #{func_name} DOESN'T HAVE VARS"
			end
		end	
	end
end

#when issuing a function call, find the caller's class
def retrieve_func_calls
	$class_map.each do |keyc, valuec|
		valuec.getMethods.each do |key, value|
			value.getCalls.each do |each_call|
				each_call.findCaller(keyc, value.getName)
			end
		end
	end
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

def parse_attrib_node(astnode)
#TODO: currently only handles single attribute node
	return get_left_most_leaf(astnode).source.to_s
end

def parse_attrib(astnode)
	case astnode.children[0].source.to_s
		when "has_many"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					$cur_class.addHasMany(parse_attrib_node(child))
				end
			end
		when "belongs_to"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					$cur_class.addBelongsTo(parse_attrib_node(child))
				end
			end
		when "has_one"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					$cur_class.addHasOne(parse_attrib_node(child))
				end
			end
		when "attr_accessor"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					$cur_class.addVariable(get_left_most_leaf(child).source.to_s)
				end
			end
		when "before_filter"
			if astnode.children[1].type.to_s == "list"
				astnode.children[1].children.each do |child|
					$cur_class.addBeforeFilter(get_left_most_leaf(child).source.to_s)
					#puts "#{$cur_class.getName} add before filter: #{get_left_most_leaf(child).source.to_s}"
				end
			end
		#else
	end
end

#parse assignment, put the assigned value into method's variable list
def parse_assign(astnode, method)
	@node = astnode
	while @node.children.length != 0 do
		@node = @node.children[0]
	end		
	method.getVars[@node.source.to_s] = astnode.source
	return @node.source.to_s
end

#parse method call, check if it is query related
def parse_method_call(astnode, method)
	@node = astnode
	while @node.children.length != 0 do
		@node = @node.children[0]
	end
	if astnode.children[1] != nil and astnode.children[1].type.to_s == "ident"

		@node2 = astnode.children[1]
		fcall = Function_call.new(@node.source, @node2.source)
		
		#if @node.type.to_s == "const" and check_table_name(@node.source.to_s)
		if check_method_keyword(@node2.source) then
			fcall.setIsQuery
			#	puts "++ CALL DB Queries: #{@node.source} . #{@node2.source}"
			#	translate_query(@node, @node2, astnode)
		end
		#end
		if astnode.children[2] != nil and astnode.children[2].type.to_s == "arg_paren"
			fcall.parseParams(astnode.children[2].children[0])
		end	
		method.getCalls.push(fcall)
		$cur_funccall = fcall
	elsif astnode.type.to_s == "command"
		parse_attrib(astnode)
		$cur_funccall  = nil
	else
		$cur_funccall = nil
	end
end

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
		#$method_map[$cur_method.getName] = $cur_method
		$cur_method = Method_class.new(@method_name)
		$cur_class.addMethod($cur_method)
		#puts "def method_name = #{@method_name}"
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
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
		parse_method_call(astnode, $cur_method)
		if $cur_position == "INCONDITION" and $cur_funccall != nil
			$cur_funccall.setReturnValue("true")
		end
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
	elsif (astnode.type.to_s == "assign" or astnode.type.to_s == "opassign")
		assigned_var = parse_assign(astnode, $cur_method)
		astnode.children.each do |child|
			if child.class.to_s == "YARD::Parser::Ruby::MethodCallNode"
				traverse_ast(child, level+1)
				if $cur_funccall != nil
					$cur_funccall.setReturnValue(assigned_var)
				end
			else
				traverse_ast(child, level+1)
			end
		end
	else
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
	end
	
	astnode.children.each do |child|
	end
end

#find the proper upper class
def resolve_upper_class
	$class_map.each do |keyc, valuec|
		if $class_map.has_key?(valuec.getUpperClass)
			valuec.setUpperClassInstance($class_map[valuec.getUpperClass])
		end
	end
end

def search_derived_class(class_handler)
	derived_classes = Array.new
	$class_map.each do |keyc, valuec|
		if keyc != class_handler.getName and valuec.getUpperClass == class_handler.getName
			derived_classes.push(valuec)
		end
	end
	return derived_classes
end

def get_mvc_name(filename)
	i = filename.rindex('/')
	j = filename.index('.')
	n = filename[i+1..j-1]
	return n
end

def set_class(ast, is_controller)
	class_name = ast.children[0].children[0].source.to_s
	if is_controller
		$cur_class = Controller_class.new(class_name)
	else
		$cur_class = Model_class.new(class_name)
	end
	if ast.children[0].children[1].type.to_s == "const_path_ref" or ast.children[0].children[1].type.to_s  == "var_ref"
		$cur_class.setUpperClass(ast.children[0].children[1].source.to_s)
		#puts "class #{class_name} < #{$cur_class.getUpperClass}"
	end
	$class_map[class_name] = $cur_class
end

def generate_method_xml(file, method, caller_class)
	file.puts("\t<method name = \"#{method.getName}\">")
	method.getCalls.each do |call|
		callerv_name = call.findCaller(caller_class, method.getName)
		callerv = $class_map[callerv_name]
		if call.isQuery
			file.puts("\t\t<query>")
			file.puts("\t\t\t<text>#{call.getObjName} . #{call.getFuncName}<\/text>")
			call.getParams.each do |param|
				if param.getVar.length > 0
					file.puts("\t\t\t<input>#{param.getVar}<\/input>")
				end
			end
			if call.getReturnValue.length > 0
				file.puts("\t\t\t<return>#{call.getReturnValue}<\/return>")
			end
			file.puts("\t\t<\/query>")
		elsif callerv != nil
			if callerv.class.to_s == "Controller_class"
				file.puts("\t\t<call class=\"#{transform_controller_name(callerv.getName)}\" class_type = \"controller\" function_name=\"#{call.getFuncName}\">")
			else
				file.puts("\t\t<call class=\"#{callerv.getName.downcase}\" class_type = \"model\" function_name=\"#{call.getFuncName}\">")
			end
			call.getParams.each do |param|
				if param.getVar.length > 0
					file.puts("\t\t\t<feed>#{param.getVar}<\/feed>")
				end
			end
			if call.getReturnValue.length > 0
				file.puts("\t\t\t<get>#{call.getReturnValue}<\/get>")
			end
			file.puts("\t\t<\/call>")
		end
	end	
	file.puts("\t<\/method>")
end

def generate_xml_files
	$class_map.each do |keyc, valuec|
		filename = ""
		if valuec.class.to_s == "Model_class"
			filename = "./xmls/#{keyc.downcase}_model.xml"
		else
			filename = "./xmls/#{transform_controller_name(keyc)}.xml"
		end
		file = File.open(filename, "w")
		puts "Generate file: #{filename}"
		if valuec.class.to_s == "Model_class"
			file.puts("<model>")
		else
			file.puts("<controller>")
		end

		valuec.getMethods.each do |key, value|
			generate_method_xml(file, value, keyc)
		end
		
		if valuec.class.to_s == "Model_class"
			file.puts("<\/model>")
		else
			file.puts("<\/controller>")
		end
	end
end

def adjust_calls
	$class_map.each do |keyc, valuec|
		valuec.getMethods.each do |key, value|
			#TODO: before filter calling function itself is not handled, loops may be generated
#			if valuec.getBeforeFilter.length > 0
#				valuec.getBeforeFilter.each do |filter|
#					fc = Function_call.new("self", filter)
#					puts "\t # \t insert call: #{valuec.getName} . #{fc.getFuncName}"
#					#if fc.getFuncName != key
#					#	value.getCalls.insert(0, fc)
#					#end
#				end	
#			end
			upper_class = $class_map[valuec.getUpperClass] 
			if upper_class != nil and upper_class.getBeforeFilter.length > 0
				upper_class.getBeforeFilter.each do |filter|
					fc = Function_call.new(upper_class.getName, filter)
					#puts "\t # \t insert call: #{upper_class.getName} . #{fc.getFuncName}"
					value.getCalls.insert(0, fc)
				end	
			end
		end
	end
end

def trace_function(start_class, start_function, params, returnv, level)
	@blank = ""
	for i in (0...level)
		@blank = @blank + "   "
	end
	class_handler = $class_map[start_class]
	function_handler = class_handler.getMethods[start_function]
	if function_handler == nil
		return 
	end
	puts "#{@blank}level #{level}: #{start_class} . #{start_function} (params: #{params}) # (returnv: #{returnv})"
	function_handler.getCalls.each do |call|
		callerv_name = call.findCaller(start_class, start_function)
		callerv = $class_map[callerv_name]
		pass_params = ""
		pass_returnv = ""
		call.getParams.each do |param|
			if param.getVar.length > 0
					pass_params += "#{param.getVar}, "
			end
		end
		pass_returnv = call.getReturnValue
		if call.isQuery
			puts "#{@blank}  [QUERY] #{call.getObjName} . #{call.getFuncName}	{params: #{pass_params}} # {returnv: #{pass_returnv}}"
		elsif callerv != nil
			trace_function(callerv_name, call.getFuncName, params, returnv, level+1)
		end
	end	
end

#iterate over all controllers
$app_dir = "/home/congy/ruby_source/yard/benchmarks"
$controller_files = ""
$model_files = ""

def read_ruby_files(application_dir=nil)
	if application_dir != nil
		$app_dir = application_dir
	end
	$controller_files = "#{$app_dir}/controllers/*.rb"
	$model_files = "#{$app_dir}/models/*.rb"
	
	Dir.glob($controller_files) do |item|
		next if item == '.' or item == '..'
		# clear global variables
		$cur_method = Method_class.new("empty_class")
		#$method_map.clear
	
		#read file
		file = File.open(item, "r")
		contents = file.read
	
		#iterate over AST
		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
		
		set_class(ast, true)
		level = 0
		traverse_ast(ast, level)
	
	end
	
	#iterate over all models
	Dir.glob($model_files) do |item|
		next if item == '.' or item == '..'
		# clear global variables
		$cur_method = Method_class.new("empty_class")
		#$method_map.clear
	
		#read file
		file = File.open(item, "r")
		contents = file.read
		
		#iterate over AST
		ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
		
		set_class(ast, false)
		level = 0
		traverse_ast(ast, level)
	
	end
	
	read_dynamic_typing_info
	resolve_upper_class
	retrieve_func_calls
end


def print_classes(class_name=nil)
	if class_name == nil
		$class_map.each do |keyc, valuec|
			valuec.print_calls
		end	
	else
		$class_map[class_name].print_calls
	end
end

def print_types(class_name=nil)
	if class_name == nil
		$class_map.each do |keyc, valuec|
			valuec.print_types
		end	
	else
		$class_map[class_name].print_types
	end
end

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: opt_parser [OPTIONS]"

  opt.on("-p","--print [:ALL]",String,"print out variable and function call names of class specified; or type all to print out all classes") do |class_name|
		options[:class_name] = class_name
		puts "#{class_name}"
    #print_classes(class_name)
  end

	opt.on("-v","--print-types [:ALL]",String,"print out type information of each variable of function call") do |class_name|
		options[:class_name_for_type] = class_name
    #print_classes(class_name)
  end

	opt.on("-t","--trace CLASS_NAME,FUNCTION_NAME",Array,"needs two arguments, class_name function_name; will print out call graph of the function specified") do |trace_input|
		options[:trace_input] = trace_input
		puts " -- #{trace_input[0]} , #{trace_input[1]}"
  end

  opt.on("-x","--xml","generate xml file, make sure directory xmls/ exists") do
   	options[:xml] = true 
  end

	opt.on("-d","--dir DIR",String,"the application directory, for example, -d /home/congy/lobsters/app") do |dir|
   	options[:dir] = dir
		puts "DIR = #{dir}" 
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

if options[:dir] != nil
	puts "dir = #{options[:dir]}"
	read_ruby_files(options[:dir])
else
	read_ruby_files
end

if options[:class_name] != nil
	if options[:class_name] == "all"
		print_classes
	else
		print_classes(options[:class_name])
	end
end

if options[:class_name_for_type] != nil
	if options[:class_name_for_type] == "all"
		print_types
	else
		print_types(options[:class_name_for_type])
	end
end

if options[:trace_input] != nil
	start_class = options[:trace_input][0]
	start_function = options[:trace_input][1]
	adjust_calls
	level = 0
	trace_function(start_class, start_function, "", "", level)
end

if options[:xml] == true
	generate_xml_files
end
