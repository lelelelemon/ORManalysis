require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
$schema_file = "../applications/lobsters/schema.rb"
def convert_tablename(name)
	_name = Array.new
	@upper = true
	name.split('').each do |c|
		if c == '_'
			@upper = true
		elsif @upper
			_name.push(c.upcase)
			@upper = false
		else
			_name.push(c)
		end
	end
	temp_name = _name.join
	return temp_name.singularize
end

def find_class(tbl_name)
	puts "Find table name: #{tbl_name}"
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
			if @cur_class == nil
				puts "read schema: class #{tbl_name} (#{convert_tablename(tbl_name)}) cannot be found!"
			end
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
