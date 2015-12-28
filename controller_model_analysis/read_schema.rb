require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
$schema_file = "../applications/lobsters/schema.rb"
def convert_tablename(name)
	_name = Array.new
	_word_list = Array.new
	name.split('').each do |c|
		if c == '_'
			_word_list.push(_name.join)
			_name = Array.new
		else
			_name.push(c)
		end
	end
	_word_list.push(_name.join)
	_word_list.each do |w|
		w[0] = w[0].capitalize
	end
	_word_list[-1] = _word_list[-1].singularize
	temp_name = _word_list.join
	return temp_name
end

def find_class(tbl_name)
	c_name = convert_tablename(tbl_name)
	#TODO: How about inherited class?
	return $class_map[c_name]
end

class Table_field
	def initialize(type, field_name)
		@type = type
		@field_name = field_name
		@attrs = Hash.new
	end
	attr_accessor :type, :field_name, :attrs
end

def read_schema(app_dir)
	$schema_file = "#{app_dir}/schema.rb"
	file = File.open($schema_file, "r")
	process_table_loop = false
	@cur_class = nil	
	file.each_line do |line|
		if line.include?("create_table")
			process_table_loop = true
			temp_attrs = line.split(" ")
			attrs = temp_attrs.reject(&:empty?)
			tbl_name = attrs[1].delete("\"").delete(",")
			@cur_class = find_class(tbl_name)
			t_field = Table_field.new("integer", "id")
			if @cur_class != nil
				@cur_class.addField(t_field)
			end
			if @cur_class == nil
				puts "read schema: class #{tbl_name} (#{convert_tablename(tbl_name)}) cannot be found!"
			end
			$table_names.push(convert_tablename(tbl_name))
		elsif line.delete(" ").delete("\n") == "end"
			process_table_loop = false
			@cur_class = nil
		elsif process_table_loop
			temp_attrs = line.split(" ")
			attrs = temp_attrs.reject(&:empty?)
			f_type = attrs[0]
			f_type = f_type.split(".")[1]
			f_name = attrs[1].delete("\"").delete(" ").delete(",")
			t_field = Table_field.new(f_type, f_name)	
			attrs.each do |attr|
				if attr.include?(": ")
					chrs = attr.split(": ")
					t_field.attrs[chs[0]] = chs[1].delete(",")
				end	
			end
			if @cur_class != nil
				@cur_class.addField(t_field)
			end
		end	
	end
end
