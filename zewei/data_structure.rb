require "yard"
load "helper.rb"

class Controller_Class
	def initialize(path)
		@path = path
		@content = readContent(@path)
		@ast = parse_content(@content)
		@functions = parseFunctions(@ast)
	end

	def getFunctions
		@functions
	end

	def getAst
		@ast
	end

	def getContent
		@content
	end

	def getPath
		@path
	end

	def readContent(path)
		return File.open(path, "r").read
	end

	def get_func_name(func_line)
		func_name = func_line.split(" ")[1]
		func_name.strip!
		return func_name
	end

	def parseFunctions(ast)
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

	def get_render_array
		render_arr = Array.new
		ast_arr = Array.new
		ast_arr.push @ast
		while ast_arr.length > 0
			cur_ast = ast_arr.pop
			if cur_ast.source.start_with? "render" 
				render_arr.push cur_ast
			else
				cur_ast.children.each do |child|
					ast_arr.push child
				end
			end
		end
		return render_arr
	end
end


class View_Class
	def initialize(path, base_path)
		@path = path
		@rb_path = path + ".rb"	
		@content = readContent(@path)		
		@rb_content = readContent(@rb_path)
		@ast = parse_content(@rb_content)

		@nested_path = get_nested_path(path, base_path)

		path.gsub! base_path, ""
		path.gsub! /\..*\.erb/, ""
		path = path[1..-1] if path.start_with?"/"
		path = path.split("/")

		@controller_name = path[0]
		@view_name = path[1]
	end

	def getNestedPath
		@nested_path
	end

	def getControllerName
		@controller_name
	end

	def getViewName
		@view_name
	end

	def getContent
		@content
	end

	def getAst
		@ast
	end

	def getRBContent
		@rb_content
	end

	def readContent(path)
		return File.open(path, "r").read
	end
	
	def parse_content(content)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	
end 
