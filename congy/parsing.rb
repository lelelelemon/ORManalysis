require 'yard'
require 'logger'
require 'optparse'

load 'func_call.rb'
load 'class_method.rb'
load 'helper.rb'
load 'parse_node.rb'
load 'generate_xml.rb'
load 'read_files.rb'
load 'traverse_ast.rb'

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

$cur_funccall = nil
$cur_position = ""

$cur_method = Method_class.new("empty_class")

$cur_class = Class_class.new("empty_class")
$class_map = Hash.new

#read table name list 
$table_names = Array.new

#read keywords list
$key_words = Array.new

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
			trace_function(callerv_name, call.getFuncName, params, pass_returnv, level+1)
		end
	end	
end

#iterate over all controllers
$app_dir = "./"
$controller_files = ""
$model_files = ""

def read_ruby_files(application_dir=nil)
	read_table_names
	read_key_words

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
  opt.banner = "Usage: ruby parsing.rb [OPTIONS]"

  opt.on("-p","--print [CLASS_NAME]",String,"print out variable and function call names of class specified; or type all to print out all classes","example: --print CommentsController or --print all") do |class_name|
		options[:class_name] = class_name
  end

	opt.on("-v","--print-types [CLASS_NAME]",String,"print out type information of each variable of function call","example: --print CommentsController or --print all") do |class_name|
		options[:class_name_for_type] = class_name
  end

	opt.on("-t","--trace CLASS_NAME,FUNCTION_NAME",Array,"needs two arguments, class_name function_name; will print out call graph of the function specified","example: --trace CommentsController,create") do |trace_input|
		options[:trace_input] = trace_input
  end

  opt.on("-x","--xml","generate xml file, make sure directory xmls/ exists") do
   	options[:xml] = true 
  end

	opt.on("-d","--dir DIR",String,"the application directory, for example, -d /home/congy/lobsters/app, by default it is ./, where the controllers/models of lobsters application is located") do |dir|
   	options[:dir] = dir
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
