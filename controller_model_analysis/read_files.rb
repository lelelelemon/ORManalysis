def read_dynamic_typing_info
	Dir.glob($log_files) do |item|
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

#read table name list 
def read_table_names(filepath)
	file_table = File.open(filepath)
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
end

#read keywords list
def read_key_words
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
end

def read_ruby_files(application_dir=nil)
	
	if application_dir != nil
		$app_dir = application_dir
	end
	$controller_files = "#{$app_dir}/controllers/*.rb"
	$model_files = "#{$app_dir}/models/*.rb"
	$log_files = "#{$app_dir}/logs/*.log"
	$table_file = "#{$app_dir}/table_name.txt"
	
	read_table_names($table_file)
	read_key_words

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


def read_ruby_files_with_template(application_dir, template_name)
	$app_dir = application_dir
	
	$controller_files = "#{$app_dir}/#{template_name}-demo/controllers/*.rb"
	$model_files = "#{$app_dir}/#{template_name}-demo/models/*.rb"
	$log_files = "#{$app_dir}/logs/*.log"
	$table_file = "#{$app_dir}/table_name.txt"

	read_table_names($table_file)
	read_key_words

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

	$controller_files = "#{$app_dir}/#{template_name}/controllers/*.rb"
	$model_files = "#{$app_dir}/#{template_name}/models/*.rb"

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
		
		set_class_with_template(ast, true)
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
		
		set_class_with_template(ast, false)
		level = 0
		traverse_ast(ast, level)
	
	end

end
