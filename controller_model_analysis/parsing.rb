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
load 'read_dataflow.rb'

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

$cur_method = nil

$cur_class = Class_class.new("empty_class")
$class_map = Hash.new

#read table name list 
$table_names = Array.new

#read keywords list
$key_words = Hash.new

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
#			upper_class = $class_map[valuec.getUpperClass] 
#			if upper_class != nil and upper_class.getBeforeFilter.length > 0
#				upper_class.getBeforeFilter.each do |filter|
#					fc = Function_call.new(upper_class.getName, filter)
#					#puts "\t # \t insert call: #{upper_class.getName} . #{fc.getFuncName}"
#					value.getCalls.insert(0, fc)
#				end	
#			end
		end
	end
end

$non_repeat_list = Array.new
def trace_function(start_class, start_function, params, returnv, level)
	blank = ""
	for i in (0...level)
		blank = blank + "\t"
	end
	class_handler = $class_map[start_class]
	function_handler = class_handler.getMethods[start_function]
	if function_handler == nil
		if is_transaction_function(start_function)
			if start_function.include?("begin")
				puts "#{blank}======transaction begin====="
			else
				puts "#{blank}======transaction end====="
			end
		end
		#puts "function #{start_class}.#{start_function} cannot be found"
		return 
	end

	#handles before_filter
	before_filter_name = "#{start_class}.before_filter"
	if $non_repeat_list.include?(before_filter_name) == false
		$non_repeat_list.push(before_filter_name)
		trace_function(start_class, "before_filter", "", "", level)
	end
	
	puts "#{blank}level #{level}: #{start_class} . #{start_function} (params: #{params}) # (returnv: #{returnv})"

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
			caller_class = nil
			if class_handler.getMethodVarMap[start_function] != nil
				caller_class = class_handler.getMethodVarMap[start_function].search_var(call.getObjName)
			end
			if caller_class == nil
				caller_class = call.getTableName
			end

			if trigger_save?(call)
				#puts "#{blank}=====transaction begin====="
				puts "#{blank}\tlevel #{(level+1)}:  [QUERY] #{call.getObjName} . #{call.getFuncName}	{params: #{pass_params}} # {returnv: #{pass_returnv}} # {op: #{caller_class}.#{call.getQueryType}}"
				if caller_class != nil
					$class_map[caller_class].getSave.each do |save_action|
						temp_name = "#{caller_class}.#{save_action.getFuncName}"
						if $non_repeat_list.include?(temp_name) == false
							$non_repeat_list.push(temp_name)
							trace_function(caller_class, save_action.getFuncName, "", "", level+2)
						end
					end
				end
				#puts "#{blank}=====transaction end====="
			else
				puts "#{blank}\tlevel #{(level+1)}:  [QUERY] #{call.getObjName} . #{call.getFuncName}	{params: #{pass_params}} # {returnv: #{pass_returnv}} # {op: #{caller_class}.#{call.getQueryType}}"
			end

		elsif callerv != nil
			temp_name = "#{callerv_name}.#{call.getFuncName}"
			if $non_repeat_list.include?(temp_name) == false
				if is_repeatable_function(call.getFuncName)==false
					$non_repeat_list.push(temp_name)
				end
				trace_function(callerv_name, call.getFuncName, params, pass_returnv, level+1)
			end
		end
	end	
end

#iterate over all controllers
$app_dir = "./lobsters"
$controller_files = ""
$model_files = ""
$log_files = ""
$table_file = ""

$type_inference = false

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
			valuec.print_var_types
		end	
	else
		$class_map[class_name].print_var_types
	end
end

def print_instructions(class_name=nil)
if class_name == nil
		$class_map.each do |keyc, valuec|
			valuec.print_instructions
		end	
	else
		$class_map[class_name].print_instructions
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

	opt.on("-d","--dir DIR",String,"the application directory, for example, -d /home/congy/lobsters/app, by default it is ./losters,","where the controllers/models/logs of lobsters application is located") do |dir|
   	options[:dir] = dir
  end

	opt.on("-a","--template NAME",String,"the application uses a template, for example Shoppe, so the template and app have separate controllers/models","the argument specifies the name of template","example: --template shoppe") do |tplt|
		options[:template] = tplt
	end

	opt.on("-i", "--only-type-inference","Only do type inference, and search method by name upon function call.","Using this option the script may not be able to resolve every function call, but no need for dynamic type logs.") do |inference|
		options[:inference] = true
	end

	opt.on("-f", "--read-flow","Read dataflow and control flow file") do |flow|
		options[:readflow] = true
	end

	opt.on("-s", "--print-instr [CLASS_NAME]",String,"Print instructions and CFG of all methods in the specified class") do |class_name|
		options[:printinstr] = class_name
	end

  opt.on("-h","--help","help") do
		options[:help] = true
    puts opt_parser
  end
end

opt_parser.parse!

if options[:help]
	exit
end

if options[:inference] == true
	$type_inference = true
end


if options[:dir] != nil
	puts "dir = #{options[:dir]}"
	if options[:template] != nil
		read_ruby_files_with_template(options[:dir], options[:template])
	else
		read_ruby_files(options[:dir])
	end
else
	read_ruby_files
end

if options[:readflow] == true
	if options[:dir] != nil
		read_dataflow(options[:dir])
	else
		read_dataflow
	end
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

if options[:printinstr] != nil
	if options[:printinstr] == "all"
		print_instructions
	else
		print_instructions(options[:printinstr])
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
