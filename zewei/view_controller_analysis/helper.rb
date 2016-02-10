require "yard"
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'

def read_content(path)
	return File.open(path, "r").read
end

def get_view_name_from_render_statement(r)
	r = r.split("\n")[0]
	r = r[6..-1] if r.start_with?"return"
	r.strip!
	r = r[6..-1] if r.start_with?"render"
	r.strip!
	while r[0] == '(' 
		r = r[1..-1]
	end
	arr = r.split(",")
	view = ""
	view_exists = false
	arr[0].strip!
	if arr[0].start_with?"\"" or arr[0].start_with?"'" or arr[0].start_with?":"
		if arr[0].include?("=>")
			arr[0].gsub! /["':]/, ""
			arr[0].gsub! " ", ""
			a = arr[0].split("=>")
			if a[0] == "partial" or a[0] == "template" or a[0] == "action"
				view = a[1]
				view_exists = true
			end
		else
			view = arr[0]
			view.gsub! /["':]/, ""
			view_exists = true
		end
	else 
		arr.each do |a|
			a.gsub! /["'\t]/, ""
			a.gsub! " ", ""
			if a.include?("=>")
				a = a.split("=>")
			elsif a.include?":" 
				a = a.split(":")		
			else 
				a = [a]
				a[1] = ""	
			end
			if a[0] == ":partial" or a[0] == ":template" or a[0] == ":action" or 
				a[0] == "partial" or a[0] == "template" or a[0] == "action" 
				view = a[1]
				view_exists = true
			end
		end
	end

	k = view.rindex("/")
	if k == nil
		view = self.get_controller_name + "_" + view
	else
		view = view[0..k-1] + "_" + view[k+1..-1]
	end
	if view_exists
		return view
	else
		return "not_valid"
	end
end

def get_filename_from_path(filename)
	i = filename.rindex('/')
	if i == nil
		return filename
	end
	n = filename[i+1..-1]
	return n
end

def get_nested_path(filepath, basepath)
	i = filepath.rindex(basepath)
	j = filepath.rindex('/')
	if i == nil or j == nil
		return ""
	end
	n = filepath[i+basepath.length..j]
	return n
end

def get_nested_path(filepath)
	j = filepath.rindex('/')
	if j == nil
		return ""
	end
	n = filepath[0..j]
	return n
end

def parse_render_params(line)
	line = line.to_s	
	line = line.split("\n")[0]
	line.gsub! /["' \t]/, ""
	if line.start_with?"render"
		line = line[6..-1]
	end
	if line.start_with?'{' or line.start_with?"("
		line = line[1..-1]
	end
	if line.end_with?')' or line.end_with? == '}'
		line = line[0..-2]
	end
	items = line.split(',')

	
	if not (items[0].include?":action" or items[0].include?":template" or items[0].include?":partial")
		return items[0]
	end

	items.each do |item|
		item.strip!
		a = item.split("=>")
		if a[0] == ':action' or a[0] == ':template' or a[0] == ':partial'
			return a[1]
		end
	end

end

def parse_rails_console_get_controller_action(line)
	line.strip!
	line = line[1..-1] if line.start_with?"{"
	line = line[0..-2] if line.end_with?"}"
	line = line.split ","
	hash = {}
	line.each do |item|
		item = item.split("=>")
		item[0].strip!
		item[1].strip!
		item[1].gsub! /['"]/, ""
		hash[item[0]] = item[1]
	end
	return hash 
end

# view: string, content of the view file
#layout: stirng, content of the kayout file
def embed_view_into_layout(view, layout)
	hash = Hash.new

	view_ast = YARD::Parser::Ruby::RubyParser.parse(view).root
	layout_ast = YARD::Parser::Ruby::RubyParser.parse(layout).root
	 
	traverse_ast layout_ast
end

def traverse_ast(ast)
	if ast.source.start_with?"yield"
		puts ast.source
		puts ast.type.to_s
	else
		ast.children.each do |child|
			traverse_ast(child)
		end
	end
end

#given an ast, search for all statements starting with the specified keywords, returning an array of string
def get_array_with_keyword(ast, keyword)
	res_arr = Array.new
	ast_arr = Array.new
	ast_arr.push @ast
	while ast_arr.length > 0
		cur_ast = ast_arr.pop
		if cur_ast.source.start_with? keyword 
			res_arr.push cur_ast.source
		else
			cur_ast.children.each do |child|
				ast_arr.push child
			end
		end
	end
	return res_arr
end

def print_rails_tag(tag_arr, named_routes_class)
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				puts "#" + tag if $log
				puts "controller: " + v[0] + ", action: " + v[1]
				url_inside = true
			end
		end
		if not url_inside
			puts tag
		end
	end

end

def get_rails_tag(tag_arr, named_routes_class)
	res = ""
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				res += ("#" + tag + "\n") if $log
				res += (v[0] + "," + v[1] + "\n")
				url_inside = true
			end
		end
		if not url_inside
			res += (tag + "\n") if $log
		end
	end
	return res
end

def get_form_for_tag(tag_arr, named_routes_class, controller_hash)
	res = ""
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				res += ("#" + tag + "\n") if $log
				res += (v[0] + "," + v[1] + "\n")
				url_inside = true
			end
		end
		if not url_inside
			res += (tag + "\n") if $log
			tag.strip!
			controller = tag.split(" ")[1]
			controller.strip!
			controller = controller[1..-1] if controller[0] == "@"
			controller = controller[0..-2] if controller.end_with?","

			controller_hash.each do |k, v|
				if controller.downcase == k.downcase.singularize
					res += (k + ",new/create")
				end
			end
		end
	end
	return res
end

def print_form_for_tag(tag_arr, named_routes_class, controller_hash)
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				puts "#" + tag if $log
				puts "" + v[0] + "," + v[1]
				url_inside = true
			end
		end
		if not url_inside
			tag.strip!
			controller = tag.split(" ")[1]
			controller.strip!
			controller = controller[1..-1] if controller[0] == "@"
			controller = controller[0..-2] if controller.end_with?","

			controller_hash.each do |k, v|
				if controller.downcase == k.downcase.singularize
					puts "" + k + ",new/create"
				end
			end
			puts tag
		end
	end
end

def get_href_tags(tag_arr, named_routes_class)
	res = ""
	rb_console_code = "route = Rails.application.routes\n"
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				res += ("#" + tag + "\n") if $log
				res += ("" + v[0] + "," + v[1] + "\n")
				url_inside = true
			end
		end
		if not url_inside
			tag2 = tag + ""
			tag.gsub! /<%.*%>/, "2"
			rb_console_code += ("route.recognize_path '" + tag + "' #" + tag2 + "\n")
		end
	end

	File.write("temp.rb", rb_console_code)

	system("rails console < temp.rb > temp2.txt")
	text = File.open("temp2.txt").read
	text.each_line do |line|
		if $log and line.start_with?"route.recognize"
				res += line
		end
		if line.start_with?"{"
			hash = parse_rails_console_get_controller_action(line)
			res += (hash[":controller"] + "," + hash[":action"] + "\n")
		end
	end
	return res
end

def get_redirect_to_tags(tag_arr, named_routes_class)
	res = ""
	rb_console_code = "route = Rails.application.routes\n"
	tag_arr.each do |tag|
		
		tag = tag[11..-1] if tag.start_with? "redirect_to" 
		tag.strip!
		tag.gsub! /["']/, ""		

		#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				res += ("#" + tag + "\n") if $log
				res += (v[0] + "," + v[1] + "\n")
				url_inside = true
			end
		end
		if not url_inside
			tag2 = tag + ""
			tag.gsub! /<%.*%>/, "2"
			rb_console_code += ("route.recognize_path '" + tag + "' #" + tag2 + "\n")
		end
	end

	File.write("temp.rb", rb_console_code)

	system("rails console < temp.rb > temp2.txt")
	
	puts "after wrtiting to temp2.txt"
	text = File.open("temp2.txt").read
	text.each_line do |line|
		puts "reading from temp2"
		if $log and line.start_with?"route.recognize"
				res += line
		end
		if line.start_with?"{"
			hash = parse_rails_console_get_controller_action(line)
			res += (hash[":controller"] + "," + hash[":action"] + "\n")
		end
	end
	return res
end

def get_render_array(ast)
	res_arr = Array.new
	ast_arr = Array.new
	ast_arr.push @ast
	while ast_arr.length > 0
		cur_ast = ast_arr.pop
		if cur_ast.source.start_with?"render" and (cur_ast.type.to_s == "fcall" or cur_ast.type.to_s == "command" or cur_ast.type.to_s == "list")
			res_arr.push cur_ast.source
		else
			cur_ast.children.each do |child|
				ast_arr.push child
			end
		end
	end
	return res_arr
end

