require "yard"
require "nokogiri"

load "helper.rb"
	
class Controller_Class
	def initialize(path, base_path)
		@path = path.dup
		path.gsub! base_path, ""
		@content = read_content(@path)
		j = path.index("_controller.rb")
		@controller = path[0..j-1]
    @ast = parse_content(@content)
    set_class_node(@ast)
    set_upper_class
    @functions = parse_functions(@ast)
    if @layout == nil
      set_default_layout
    end
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
  def set_class_node(astnode)
    if astnode.type.to_s == "class"
      @class_node = astnode
    else
      astnode.children.each do |child|
        set_class_node(child)
      end
    end
  end
  def set_upper_class(upper_class = nil)
    if upper_class != nil
      @upper_class = upper_class
    else
      if @class_node.children[1].type.to_s == "const_path_ref" or @class_node.children[1].type.to_s == "var_ref"
        puts @controller + "<" +  @class_node.children[1].source.to_s
        @upper_class = @class_node.children[1].source.to_s
      end
    end
  end
	#traverse the ast of the controller class and get all action functions stored in its function hash
	def parse_functions(ast)
		functions = Hash.new
		ast_arr = Array.new
		ast_arr.push ast
		while ast_arr.length > 0
      cur_ast = ast_arr.pop

      #handle layout
      if cur_ast.type.to_s == "command" and cur_ast.source.to_s.start_with?"layout"
        @layout = cur_ast.children[1].source.to_s
        @layout.gsub! /['"]/, ""
      end

      if cur_ast.type.to_s == "def"

        func_name = get_func_name(cur_ast.source.split("\n")[0])
				source = cur_ast.source
				source.strip!
				functions[func_name] = Function_Class.new(self, source)
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
  def set_default_layout
    puts "controller: " + @controller
    puts "default layout: " + "layouts/" + @controller
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

	def to_str
		return self.get_controller_name + "_" + self.get_function_name
	end

	def parse_content(content)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	def get_content
		return @content
	end

	# get the class where the action function is defined
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
	
	def get_render_statement_array(ast=nil)
		keyword = "render"
		ast = @ast if ast == nil
		res_arr = Array.new
		ast_arr = Array.new
		ast_arr.push ast
		while ast_arr.length > 0
			cur_ast = ast_arr.pop
			if cur_ast.source.start_with? keyword
				if cur_ast.parent.source.start_with?"return" 
					res_arr.push cur_ast.parent.source
				else 
					res_arr.push cur_ast.source
				end
			else
				cur_ast.children.each do |child|
					ast_arr.push child
				end
			end
		end
		return res_arr
	end

	def get_links_controller_view_recursively(view_class_hash, named_routes, controller_hash)
		res = ""
		render_stmt_arr = get_render_statement_array
		
		#view_name_arr contains the names of view files that will be rendered in the current controller action
		view_name_arr = []		

		render_stmt_arr.each do |stmt|
			view_name = get_view_name_from_render_statement(stmt)
			view_name_arr.push view_name
		end

		#the view file with the same name of the current controller action may also be rendered by default

		view_name_arr.push self.get_controller_name + "_" + self.get_function_name unless view_name_arr.include?(self.get_controller_name + "_" + self.get_function_name)
		
		view_name_arr.each do |view_name|
			if view_name != "not_valid"
				view_class = view_class_hash[view_name]
				if view_class == nil
					res += ("view file " + view_name + " not exists!") if $log
				else
					res += (view_class.get_links_controller_view_recursively(view_class_hash, named_routes, controller_hash) + "\n")
				end
			end
		end
			
		res += ("\n---redirect_to tags in " + self.get_controller_name + "_" + self.get_function_name + ": \n") if $log
		redirect_to_arr = self.get_redirect_to_array 
		res += get_redirect_to_tags(redirect_to_arr, named_routes, self.get_controller_name)
		return res
	end

	# get the mapping of render statemnets to view file content	
	def get_render_view_mapping(view_class_hash)
		render_view_mapping = Hash.new

		self.get_render_statement_array.each do |r|
			
			view_name = get_view_name_from_render_statement(r)
			if view_name != "not_valid"
				view_class = view_class_hash[view_name]
			
				if view_class != nil
					value = view_class.replace_render_statements(view_class_hash, 0)
					render_view_mapping[r] = value
				else
					#do something the view file does not exist! It could mean we parse the file wrong. 
				end
			end
		end
	
		return render_view_mapping	
	end

	def replace_render_statements(view_class_hash)
	  


    render_view_mapping = self.get_render_view_mapping(view_class_hash)
		content = self.get_content.dup
		
		need_default_render = true
		temp = content.split("\n")
		#if the second last line contains "render" or "redirect_to" we assume that we don't need to do default rendering
		need_default_render = false if temp[temp.length-2].include?"render" or temp[temp.length-2].include?"redirect_to"
		
		render_view_mapping.each do |k, v|
			content.gsub! k, "ruby_code_from_view.ruby_code_from_view do |rb_from_view|\n" + v + "\nend\n"
		end

		#we need to append the default view at the end of the function, this may be inaccuate because some views may already been rendered, we need to figure out a way to avoid duplicated rendering
		if need_default_render
			view_name = self.get_controller_name + "_" + self.get_function_name
			view_class = view_class_hash[view_name]
			if view_class != nil
				value = view_class.replace_render_statements(view_class_hash, 0)
				content = content.split "\n"
				len = content.length
				content[len] = content[len-1]
				content[len-1] = "ruby_code_from_view.ruby_code_from_view do |rb_from_view|\n" + value + "\nend\n"
				content = content.join("\n")
			else
				#do something the view file does not exist! It could mean we parse the file wrong. 
			end
		end


		return content
	end

	def get_render_views_ast(view_class_hash)
		content = self.replace_render_statements(view_class_hash)
		return YARD::Parser::Ruby::RubyParser.parse(content).root
	end

	def get_render_views_recursively(view_class_hash)
		ast = self.get_render_views_ast(view_class_hash)
		return self.get_render_statement_array(ast)
	end
end 




class View_Class
	def initialize(path, base_path)
		@path = path.dup
		@rb_path = path + ".rb"	
		@content = read_content(@path)		
		@rb_content = read_content(@rb_path)
		@ast = parse_content(@rb_content)

		if path.include?".html."
			@file_type = "html"
		elsif path.include?".rss."
			@file_type = "rss"
		elsif path.include?".js."
			@file_type = "js"
		elsif path.include?".text."
			@file_type = "text"
		else
			@file_type = "unrecognized_file_type"
			puts "WARNING: unrecognized file type " + @file_type + ", path: " + @path
		end

		path.gsub! base_path, ""
		while path[0] == '/'
			path = path[1..-1]
		end
		i = path.rindex("/")
		@view_name = path[i+1..-1]
		while @view_name[0] == "_"
			@view_name = @view_name[1..-1]
		end
		j = @view_name.index(".")
		@view_name = @view_name[0..j-1]
    puts "view_name: " + @view_name
#		if @file_type == "rss" or @file_type == "js"
#			@view_name += ("." + @file_type)
#		end

		@controller_name = path[0..i-1]
	end

	def get_controller_name
		@controller_name
	end

	def get_view_name
		@view_name
	end

	def get_file_type
		@file_type
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
    puts @path
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
			res.push(form.to_s)
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

	# This function is used to get all render statements recursively, so we can know what view files will be rendered by this controller action, further, we can get the information about what links exist in the corresponding view files
	def get_render_statements_recursively(view_class_hash, dep)
    return [] if dep > 10
		render_arr = []
		render_stmt_arr = []
		get_render_statement_array.each do |stmt|
			render_stmt_arr.push stmt
			render_arr.push get_view_name_from_render_statement(stmt)
		end
		render_stmt_arr.each do |stmt|
			view_name = get_view_name_from_render_statement(stmt)
      puts "render statement: " + stmt
      puts "view_name: " + view_name
			if view_name != "not_valid"	
			  view_class = view_class_hash[view_name]
				if view_class != nil
          _render_arr = view_class.get_render_statements_recursively(view_class_hash, dep + 1)
          _render_arr.each do |_stmt|
            render_arr.push _stmt
          end
        end
			end
		end
		return render_arr
	end

	def get_links_controller_view_recursively(view_class_hash, named_routes, controller_hash)
		res = ""
    res += self.get_all_links_controller_view(named_routes, controller_hash)
    res += "\n"

    view_arr = get_render_statements_recursively(view_class_hash, 0)

		view_arr.each do |view_name|
      puts "view_name: " + view_name
			if view_name != "not_valid"
				view_class = view_class_hash[view_name]
			  if view_class != nil
          res += view_class.get_all_links_controller_view(named_routes, controller_hash)
	  			res += "\n"
        end
			end
		end
		return res
	end

#	get a hash of hash[render_statement] = view_file_content
#	the render statements inside view_file_content will be replaces recursively before it is assigned to the hash
	def get_render_view_mapping(view_class_hash, dep)
		render_view_mapping = Hash.new

		self.get_render_statement_array.each do |r|
			view_name = get_view_name_from_render_statement(r)
			
			if view_name != "not_valid"
				view_class = view_class_hash[view_name]
        puts "view_name: " + view_name
				if view_class != nil
					value = view_class.replace_render_statements(view_class_hash, dep+1)
					render_view_mapping[r] = value
				else
					#do something if the view file does not exisst
				end
			end
		end
		
		return render_view_mapping	
	end

#replace the render statements inside the ruby code of current view file
	def replace_render_statements(view_class_hash, dep)
    return self.get_rb_content if dep > 10
		render_view_mapping = self.get_render_view_mapping(view_class_hash, dep)
		rb_content = self.get_rb_content.dup 
		puts "------------------------------current view file: " + self.to_str
		render_view_mapping.each do |k, v|
			puts "key: " + k
			puts "value: " + v
			rb_content.gsub! k, v
		end

		return rb_content
	end

	def get_all_links_controller_view(named_routes, controller_hash)
		if @links_controller_view == nil 
			indent = "---"
			res = ""
			if $log
				res += (indent + "controller: " + self.get_controller_name + "\n")
				res += (indent + "view: " + self.get_view_name + "\n")
				res += (indent + "hrefs: \n")
			end
			res += (get_href_tags(self.get_href_tag_array_from_html, named_routes) + "\n")
			res += (indent + "forms: \n") if $log
			res += (get_rails_tag(self.get_form_tag_array_from_html, named_routes) + "\n")
			res += (indent + "form_for: \n") if $log
			res += (get_form_for_tag(self.get_form_for_array, named_routes, controller_hash))
			res += (indent + "link_to: \n") if $log

			res += (get_link_to_tags(self.get_link_to_array, named_routes, self.get_controller_name) + "\n")  
			@links_controller_view = res
		end
		@links_controller_view 
	end

	def to_str
		@controller_name + "_" + @view_name
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
