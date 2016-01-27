require "yard"
require "nokogiri"

load "helper.rb"

def read_content(path)
	return File.open(path, "r").read
end

class Controller_Class
	def initialize(path)
		@path = path
		@content = read_content(@path)
		i = path.rindex("/")
		j = path.index("_controller.rb")
		@controller = path[i+1, j-18]
		@ast = parse_content(@content)
		@functions = parse_functions(@ast)
		
	end

	def get_controller_name
		@controller
	end

	def get_functions
		@functions
	end

	def get_ast
		@ast
	end

	def get_content
		@content
	end

	def get_path
		@path
	end

	def get_func_name(func_line)
		func_name = func_line.split(" ")[1]
		func_name.strip!
		return func_name
	end

	def parse_functions(ast)
		functions = Hash.new
		ast_arr = Array.new
		ast_arr.push ast
		while ast_arr.length > 0
			cur_ast = ast_arr.pop
			if cur_ast.type.to_s == "def" 
				func_name = get_func_name(cur_ast.source.split("\n")[0])
				functions[func_name] = Function_Class.new(self, cur_ast.source)
			else
				cur_ast.children.each do |child|
					ast_arr.push child
				end
			end
		end
		return functions
	end

	def parse_content(content)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	
end

class Function_Class
	def initialize(controller_class, content)
		@class = controller_class
		@content = content
		@ast = parse_content(@content)
		@function_name = content.split("\n")[0]
		@function_name.strip!
		@function_name = @function_name.split(" ")[1]
		i = @function_name.rindex("(")
		if i != nil
			@function_name = @function_name[0..i-1]
		end
	end

	def parse_content(content)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	def get_content
		@content
	end

	def get_class 
		@class
	end

	def get_controller_name
		return @class.get_controller_name
	end

	def get_function_name
		@function_name
	end

	def get_render_array
		get_array_with_keyword @ast, "render"
	end

	def get_redirect_to_array 
		get_array_with_keyword @ast, "redirect_to"
	end
	
	def get_render_statement_array
		get_array_with_keyword @ast, "render"
	end
	
	def get_render_view_mapping(view_class_hash)
		render_view_mapping = Hash.new

		self.get_render_statement_array.each do |r|
			view_name = get_view_name_from_render_statement(r)
			view_class = view_class_hash[view_name]
					
	
			if view_class != nil
				value = view_class.replace_render_statements(view_class_hash)
				render_view_mapping[r] = value
			end
		end
	
		return render_view_mapping	
	end

	def get_view_name_from_render_statement(r)
		r = r.split("\n")[0]
		r = r[6..-1] if r.start_with?"render"
		while r[0] == '(' 
			r = r[1..-1]
		end

		arr = r.split(",")
		view = self.get_controller_name + "_" + self.get_function_name

		arr[0].strip!
		if arr[0].start_with?"\"" or arr[0].start_with?"'"
			view = arr[0]
		else 
			arr.each do |a|
				a.gsub! " ", ""
				a.gsub! "\"", ""
				a.gsub! "'", ""
				a.gsub! "\t", ""
				a = a.split("=>")
				if a[0] == ":partial" or a[0] == ":template" or a[0] == ":action" 
					view = a[1]
				end
			end
		end

		k = view.rindex("/")
		if k == nil
			view = self.get_controller_name + "_" + view
		else
			view = view[0..k-1] + "_" + view[k+1..-1]
		end
		#puts "view: " + view
		return view
	end

	def replace_render_statements(view_class_hash)
		render_view_mapping = self.get_render_view_mapping(view_class_hash)
		content = self.get_content
		render_view_mapping.each do |k, v|
			content.gsub! k, v
		end
		return content
	end
end 




class View_Class
	def initialize(path, base_path)
		@path = path
		@rb_path = path + ".rb"	
		@content = read_content(@path)		
		@rb_content = read_content(@rb_path)
		@ast = parse_content(@rb_content)

		path.gsub! base_path, ""
		while path[0] == '/'
			path = path[1..-1]
		end
		i = path.rindex("/")
		@view_name = path[i+1..-1]
		j = @view_name.index(".")
		@view_name = @view_name[0..j-1]
		while @view_name[0] == '_'
			@view_name = @view_name[1..-1]
		end

		@controller_name = path[0..i-1]
	end

	def get_controller_name
		@controller_name
	end

	def get_view_name
		@view_name
	end

	def get_content
		@content
	end

	def get_ast
		@ast
	end

	def get_rb_content
		@rb_content
	end

	
	def parse_content(content)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	def get_href_tag_array_from_html

		page = Nokogiri::HTML(get_content)
		res = Array.new
		page.css("a").each do |a|

			href = a["href"]
			href = "" if href == nil
			res.push(href)
		end
		return res
	end

	def get_form_tag_array_from_html
		page = Nokogiri::HTML(get_content)
		res = Array.new
		page.css("form").each do |form|
			res.push(form)
		end
		return res
	end
	
	def get_form_for_array 
		get_array_with_keyword @ast, "form_for"
	end
	
	def get_link_to_array 
		get_array_with_keyword @ast, "link_to"
	end
	
	def get_button_to_array 
		get_array_with_keyword @ast, "button_to"
	end

	def get_render_statement_array
		get_render_array @ast
	end

#	get a hash of hash[render_statement] = view_file_content
#	the render statements inside view_file_content will be replaces recursively before it is assigned to the hash
	def get_render_view_mapping(view_class_hash)
		render_view_mapping = Hash.new

		self.get_render_statement_array.each do |r|
			view_name = get_view_name_from_render_statement(r)
			view_class = view_class_hash[view_name]
		
			#puts "render: " + r
			#puts "view_name: " + view_name
	
			if view_class != nil
				#puts "view_file: " + view_class.get_controller_name + ", " + view_class.get_view_name
				value = view_class.replace_render_statements(view_class_hash)
				render_view_mapping[r] = view_class.replace_render_statements(view_class_hash)
			end
		end
	
		return render_view_mapping	
	end

	def get_view_name_from_render_statement(r)
		r = r.split("\n")[0]
		r = r[6..-1] if r.start_with?"render"
		while r[0] == '(' 
			r = r[1..-1]
		end

		arr = r.split(",")
		view = self.get_controller_name + "_" + self.get_view_name
		arr[0].strip!
		if arr[0].start_with?"\"" or arr[0].start_with?"'"
			view = arr[0]
		else 
			arr.each do |a|
				a.gsub! " ", ""
				a.gsub! "\"", ""
				a.gsub! "'", ""
				a.gsub! "\t", ""
				a = a.split("=>")
				if a[0] == ":partial" or a[0] == ":template" or a[0] == ":action" 
					view = a[1]
				end
			end
		end

		k = view.rindex("/")
		if k == nil
			view = self.get_controller_name + "_" + view
		else
			view = view[0..k-1] + "_" + view[k+1..-1]
		end
		return view
	end

	def replace_render_statements(view_class_hash)
		render_view_mapping = self.get_render_view_mapping(view_class_hash)
		rb_content = self.get_rb_content
		render_view_mapping.each do |k, v|
			#puts "key: " + k
			rb_content.gsub! k, v
		end
		return rb_content
	end
end 


class Named_Routes_Class
	def initialize(path)
		@path = path
		@content = read_content(path)
		@named_routes = parse_content(@content)		
	end

	def get_path
		@path
	end

	def get_content
		@content
	end

	def get_named_routes
		@named_routes
	end

	def parse_content(content)
		res = Hash.new

		lines = content.split "\n"
		num_of_lines = lines.length
		i = 0
		while i < num_of_lines
			lines[i].strip
			helper = lines[i]

			lines[i+1] = lines[i+1][1..lines[i+1].rindex('}')-1]
			lines[i+1].gsub! "\"", ""
			items = lines[i+1].split ","
			hash = Hash.new
			items.each do |item|
				item.strip!
				a = item.split "=>"
				hash[a[0]] = a[1]
			end
			
			res[helper + "_path"] = [hash[":controller"], hash[":action"]]			
			res[helper + "_url"] = [hash[":controller"], hash[":action"]]			
			i += 2
		end
		res
	end	
end
