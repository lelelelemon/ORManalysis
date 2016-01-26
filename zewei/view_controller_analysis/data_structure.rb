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
		@ast = parse_content(@content)
		@functions = parse_functions(@ast)
		
		i = path.rindex("/")
		j = path.index("_controller.rb")
		@controller = path[i+1, j-1]
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

	def get_redirect_to_array

	end

	def get_render_array
		get_array_with_keyword @ast, "render"
	end

	def get_redirect_to_array 
		get_array_with_keyword @ast, "redirect_to"
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
