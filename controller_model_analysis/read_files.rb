def read_dynamic_typing_info
	Dir.glob($log_files) do |item|
		next if item == '.' or item == '..'
		class_name = get_mvc_name(item)
		class_handler = nil
		if $class_map.has_key?(class_name) == false
			$class_map.each do |keyc, valuec|
				if keyc.include?("::") and remove_module_info(keyc) == class_name
					class_handler = valuec
				end
			end
		else
			class_handler = $class_map[class_name]
		end
		if class_handler == nil
			$class_map.each do |kc, vc|
				#puts "#{kc}"
				n_split = kc.split("::")
				n_split.each do |nn|
					if class_name == nn
						class_handler = vc
					end
				end
		end
		end
		if class_handler == nil
			abort("Class #{class_name} (#{item}) cannot be found!")
		end
		file = File.open(item, "r")
		file.each_line do |line|
			c_array = line.split(": ")
			func_name = c_array[0].chomp
			if c_array.length > 1
				var_name = c_array[1].split(" -> ")[0].chomp
				class_name = c_array[1].split(" -> ")[1].chomp
				class_handler.addMethodVar(func_name, var_name, class_name)	
			#elsif
			#	puts "FUNCTION #{func_name} DOESN'T HAVE VARS"
			end
		end	
	end
end

def read_each_class(class_list, module_name)
	class_list.each do |class_node|
		if module_name == "" or class_node.children[0].source.to_s.include?(module_name)
			class_name = class_node.children[0].source.to_s
		else
			class_name = "#{module_name}::#{class_node.children[0].source.to_s}"
		end
		#puts "\t -- class_name = #{class_name}"
		#puts ""
		#if is_controller
		#	$cur_class = Controller_class.new(class_name)
		#else
		#	$cur_class = Model_class.new(class_name)
		#end
		$cur_class = Class_class.new(class_name)
		if class_node.children[1].type.to_s == "const_path_ref" or class_node.children[1].type.to_s  == "var_ref"
			#upper_class = class_node.children[1].source.to_s
			$cur_class.setUpperClass(class_node.children[1].source.to_s)
		#puts "class #{class_name} < #{$cur_class.getUpperClass}"
		end
		
		$class_map[class_name] = $cur_class
		level = 0
		traverse_ast(class_node, level)
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
		line_array = line.chomp.split(' ')
		$key_words[line_array[0]] = line_array[1]
	end
end

def handle_single_file(item)
	file = File.open(item, "r")
	contents = file.read
	ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
	class_list = Array.new
	module_node = get_module_node(ast)
	module_name = ""
	if module_node != nil
		module_name = get_left_most_leaf(module_node).source.to_s
	end
	get_class_list(ast, class_list)
	if class_list.length == 0
		if module_node != nil
			class_list.push(module_node)
			read_each_class(class_list, "")
		else
			abort("Neither class nor module can be found")
		end
	else
		#puts "class_list:"
		#class_list.each do |c|
		#	puts "\t--#{c.children[0].source.to_s}"
		#end
		read_each_class(class_list, module_name)
	end
end


def read_ruby_files(application_dir=nil)
	
	if application_dir != nil
		$app_dir = application_dir
	end
	$log_files = "#{$app_dir}/logs/*.log"
	$table_file = "#{$app_dir}/table_name.txt"
	
	#read_table_names($table_file)
	read_key_words

	Dir.foreach($app_dir) do |item|
		next if item == '.' or item == '..'
		#first level: all folders
		if item.include?('.') == false
			dir_name = "#{$app_dir}/#{item}"
			Dir.foreach(dir_name) do |sub_item|
				next if sub_item == '.' or sub_item == '..'
				if sub_item.include?(".rb") == false
					sub_dir_name = "#{dir_name}/#{sub_item}/*.rb"
					Dir.glob(sub_dir_name) do |item1|
						handle_single_file(item1)
					end
				else
					fname = "#{dir_name}/#{sub_item}"
					handle_single_file(fname)
				end
			end
		end
	end
	
	if $type_inference == false
		read_dynamic_typing_info
	end

	
	#TODO: It should recursively resolve upper class, here I just hope the inherit length is less than 2...
	resolve_upper_class
	resolve_upper_class
	if $read_schema
		read_schema($app_dir)
	end
	retrieve_func_calls

end


def read_ruby_files_with_template(application_dir, template_name)
=begin
	$app_dir = application_dir
	
	#read demo
	$controller_files = "#{$app_dir}/#{template_name}-demo/controllers/"
	$model_files = "#{$app_dir}/#{template_name}-demo/models/"
	$log_files = "#{$app_dir}/logs/*.log"
	$table_file = "#{$app_dir}/table_name.txt"

	read_table_names($table_file)
	read_key_words

	Dir.foreach($controller_files) do |item|
		next if item == '.' or item == '..'
		if item.include?(".rb") == false
			dir_name = "#{$controller_files}/#{item}/*.rb"
			Dir.glob(dir_name) do |item1|
				handle_single_file(item1, true)
			end
		else
			fname = "#{$controller_files}/#{item}"
			handle_single_file(fname, true)
		end
	end
	
	#iterate over all models
	Dir.foreach($model_files) do |item|
		next if item == '.' or item == '..'
		if item.include?(".rb") == false
			dir_name = "#{$model_files}/#{item}/*.rb"
			Dir.glob(dir_name) do |item1|
				handle_single_file(item1, false)
			end
		else
			fname = "#{$model_files}/#{item}"
			handle_single_file(fname, false)
		end
	end

	#read template
	$controller_files = "#{$app_dir}/#{template_name}/controllers/"
	$model_files = "#{$app_dir}/#{template_name}/models/"

	Dir.foreach($controller_files) do |item|
		next if item == '.' or item == '..'
		if item.include?(".rb") == false
			dir_name = "#{$controller_files}/#{item}/*.rb"
			Dir.glob(dir_name) do |item1|
				handle_single_file(item1, true)
			end
		else
			fname = "#{$controller_files}/#{item}"
			handle_single_file(fname, true)
		end
	end
	
	#iterate over all models
	Dir.foreach($model_files) do |item|
		next if item == '.' or item == '..'
		if item.include?(".rb") == false
			dir_name = "#{$model_files}/#{item}/*.rb"
			Dir.glob(dir_name) do |item1|
				handle_single_file(item1, false)
			end
		else
			fname = "#{$model_files}/#{item}"
			handle_single_file(fname, false)
		end
	end

	if $type_inference == false
		read_dynamic_typing_info
	end
	resolve_upper_class
	resolve_upper_class
	read_schema
	retrieve_func_calls
=end
end
