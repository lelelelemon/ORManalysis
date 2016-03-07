require "yard"
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'

def read_content(path)
	return File.open(path, "r").read
end

def get_func_name(func_line)
  func_line.strip!
  func_name = func_line[3..-1] if func_line.start_with?"def"
  func_name.strip!
  func_name.gsub! /\(.*\)/, ""
  return func_name
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

def parse_params(tag, curr_controller)
  tag.gsub! /["':{}]/, ""
  url_params = tag.split ","
  
  hash = {}
  url_params.each do |p|
    puts p
    arr = p.split("=>")
    arr[0].strip!
    if arr[1] != nil
      arr[1].strip!
      hash[arr[0]] = arr[1]
    else
      hash[arr[0]] = ""
    end
  end

  hash.each do |k, v|
    puts "k: " + k
    puts "v: " + v
  end

  res = ""
  if hash.has_key?"controller"
    res += hash["controller"]
  else
    res += curr_controller
  end

  if hash.has_key?"action"
    res += ("," + hash["action"] + "\n")
  else
    res += ",\n"
  end
  return res
end

#tag_arr: an array of all link_to statements
#named_routes_class: all named routes
def get_link_to_tags(tag_arr, named_routes_class, curr_controller)
  
  res = ""
  rb_console_code = "route = Rails.application.routes\n"
  tag_arr.each do |tag|
    puts "link_to: " + tag
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
      tag2 = tag.dup #back up tag
      tag.strip!
      tag = tag[7..-1] if tag.start_with?"link_to"
      tag.strip!
      tag = tag[1..-2] if tag.start_with?"(" and tag.end_with?")"
      #the url of the link may be specified by the controller and action parameters
      if tag.include?"controller" and tag.include?"action"
        res += ("#" + tag + "\n") if $log
        res += parse_params(tag, curr_controller)
      else
        params = tag.split ","
        url = params[1]
        if url != nil 
          url.strip!
          url.gsub /['"]/, ""
          url.gsub! /<%.*%>/, "2"
          rb_console_code += ("route.recognize_path '" + url + "' #" + tag2 + "\n")
        else
          res += (tag2 + "\n")
        end
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

def get_redirect_to_tags(tag_arr, named_routes_class, curr_controller)
	res = ""
	rb_console_code = "route = Rails.application.routes\n"
	tag_arr.each do |tag|
		
    tag2 = tag.dup
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
      #redirect_to :controller => 'projects', :action => 'edit', :id => @milestone.project
		  	
			if tag.include?"controller" and tag.include?"action"
        res += (tag2 + "\n") if $log
        res += parse_params(tag, curr_controller)
      else
        tag.gsub! /<%.*%>/, "2"
        rb_console_code += ("route.recognize_path '" + tag + "' #" + tag2 + "\n")
      end
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

