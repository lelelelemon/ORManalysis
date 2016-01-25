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

	def get_href_tags

		page = Nokogiri::HTML(get_content)
		res = ""
		page.css("a").each do |a|

			href = a["href"]
			href = "" if href == nil
			res += href
			res += "\n"
		end
		return res
	end

	def get_form_tags
		page = Nokogiri::HTML(get_content)
		res = ""
		page.css("form").each do |form|
			res += form
			res += "\n"
		end
		return res
	end
	
	def get_form_for_array 
		get_array_with_keyword @ast, "form_for"
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

	
end
