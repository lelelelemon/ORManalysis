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

#read table name list 
def read_table_names
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
