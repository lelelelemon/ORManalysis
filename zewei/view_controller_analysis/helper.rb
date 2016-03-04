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

def get_view_name_from_render_statement2(r)
  puts r
  view = nil
  ast = YARD::Parser::Ruby::RubyParser.parse(r).root
  if ast.type.to_s == "list"
    ast = ast[0]
  end
  if ast.type.to_s == "if_mod" or ast.type.to_s == "unless_mod"
    ast = ast[1]
  end
  if ast[0].source.to_s != "render"
    return "not_valid"
  end
  params = ast[1][0]
  puts params.type.to_s
  puts params.source.to_s
  if params[0].type.to_s == "string_literal"
    view =  params[0].source.to_s
  elsif params[0].type.to_s == "symbol_literal"
    view = params[0].source.to_s
  elsif params[0].type.to_s == "vcall"
    view = params[0].source.to_s
  elsif params[0].type.to_s == "var_ref"
    view = params[0].source.to_s
  else
    puts params.type.to_s
    puts params.source.to_s
    params.children.each do |assoc|
      if assoc[0].source.to_s == "partial" or 
        assoc[0].source.to_s == "template" or 
        assoc[0].source.to_s == "action" or 
        assoc[0].source.to_s == ":partial" or 
        assoc[0].source.to_s == ":template" or 
        assoc[0].source.to_s == ":action" 
        view = assoc[1].source.to_s
      end
    end
  end

  puts "raw view: " 
  if view == nil
    return "not_valid"
  end
  if view.end_with?".html.erb"
    view = view[0..-10]
  end
  view.gsub! /["':]/, ""
  k = view.rindex("/")
  if k == nil
    view = self.get_controller_name + "_" + view
  else
    view = view[0..k-1] + "_" + view[k+1..-1]
  end
  puts view
  return view
end

def get_view_name_from_render_statement(r)
	r = r.split("\n")[0]
	r = r[6..-1] if r.start_with?"return"
  r = r[17..-1] if r.start_with?"escape_javascript"
	r.strip!
  while r[0] == '(' 
    r = r[1..-1]
  end
  while r[-1] == ')'
    r = r[0..-2]
  end
	r = r[6..-1] if r.start_with?"render"
	r.strip!
	while r[0] == '(' 
		r = r[1..-1]
	end
  while r[-1] == ')'
    r = r[0..-2]
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
        while view[0] == '/'
          view = view[1..-1]
        end
				view_exists = true
			end
		else
			view = arr[0]
			view.gsub! /["':]/, ""
      while view[0] == '/'
        view = view[1..-1]
      end
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
        while view[0] == '/'
          view = view[1..-1]
        end
				view_exists = true
			end
		end
	end

  if view.end_with?".html.erb"
    view = view[0..-10]
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

def get_render_array(ast)
	res_arr = Array.new
	ast_arr = Array.new
	ast_arr.push @ast
	while ast_arr.length > 0
		cur_ast = ast_arr.pop
		if cur_ast.source.start_with?"render" and (cur_ast.type.to_s == "fcall" or cur_ast.type.to_s == "command" or 
                                               cur_ast.type.to_s == "list" or cur_ast.type.to_s == "if_mod" or cur_ast.type.to_s == "unless_mod")
			res_arr.push cur_ast.source
		else
			cur_ast.children.each do |child|
				ast_arr.push child
			end
		end
	end
	return res_arr
end

def merge_layout_content(layout, content)
  puts layout
  layout_ast = YARD::Parser::Ruby::RubyParser.parse(layout).root
  puts content
  content_ast = YARD::Parser::Ruby::RubyParser.parse(content).root

  content_hash = {}
  proc_merge_layout_content(content_ast, content_hash)

  content_hash.each do |key, value|
    if layout.include?"yield(#{key})"
      layout.gsub! "yield(#{key})", value
      content.gsub! value, ""
    elsif layout.include?"yield #{key}"
      layout.gsub! "yield #{key}", value
      content.gsub! value, ""
    end
  end

  #handle a special case for jobsworth
  if content_hash.has_key?":content"
    layout.gsub! "content_for?(:content) ? yield(:content) : yield ", content_hash["content_for?(:content) ? yield(:content) : yield "]
    content.gsub! "content_for?(:content) ? yield(:content) : yield ", ""
  end

  if layout.include?"yield\n"
    layout.gsub! "yield\n", content
  end

  if layout.include?"yield \n"
    layout.gsub! "yield \n", content
  end

  #handle a special case for jobsworth
  layout.gsub! "content_for?(:content) ? yield(:content) : yield ", content

  return layout
end

def proc_merge_layout_content(content_ast, content_hash)
  if content_ast != nil and content_ast.source.to_s.start_with?"content_for"
    key = content_ast.source.to_s
    value = content_ast.children[1].source.to_s
    key.strip!
    content_hash[key] = value
  else
    content_ast.children.each do |child|
      proc_merge_layout_content(child, content_hash)
    end
  end
end


def get_layout_name_from_render_statement(r)
  r = r.split("\n")[0]
  r = r[6..-1] if r.start_with?"return"
  r.strip!
  r = r[6..-1] if r.start_with?"render"
  r.strip!
  while r[0] == '(' 
    r = r[1..-1]
  end
  while r[-1] == ')'
    r = r[0..-2]
  end
  arr = r.split(",")
  layout = ""
  layout_exists = false
  arr[0].strip!
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
    if a[0] == ":layout" or a[0] == "layout"
      layout = a[1]
      while layout[0] == '/'
        layout = layout[1..-1]
      end
      layout_exists = true
    end
  end

  if layout.end_with?".html.erb"
    layout.gsub! ".html.erb", ""
  end

  if layout_exists
    return layout
  else
    return "not_valid"
  end
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
      #if cur_ast.parent.source.start_with?"return" 

#      if cur_ast.parent.type.to_s.eql?(["arg_paran"]) and cur_ast.parent.parent.type.to_s.eql?(["fcall", "return", "command"])
#        res = cur_ast.parent.parent.source.to_s
#      elsif cur_ast.parent.type.to_s.eql?(["return", "fcall", "command"])
#        res = cur_ast.parent.source.to_s
#     	else 
#        res = cur_ast.source.to_s
#     	end
      #
      if cur_ast.parent.parent != nil and cur_ast.parent.parent.source.start_with?"escape"
        puts "escape: !!"
        puts cur_ast.parent.type
        puts cur_ast.parent.parent.source
      end

      if cur_ast.parent.parent != nil and cur_ast.parent.parent.source.start_with?"escape_javascript("
        res = cur_ast.parent.parent.source.to_s
      elsif cur_ast.parent.type.to_s.eql?(["arg_paren"]) and cur_ast.parent.parent.source.to_s.start_with?("return(", "escape_javascript(")
        res = cur_ast.parent.parent.source.to_s
      elsif cur_ast.parent.source.to_s.start_with?("return", "escape_javascript")
        res = cur_ast.parent.source.to_s
      else
        res =  cur_ast.source.to_s
      end

      if res.end_with?"\ne" or res.end_with?"\te" or res.end_with?" e"
        res = res[0..-2]
      end
      res_arr.push res
    else
      cur_ast.children.each do |child|
        ast_arr.push child
      end
    end
  end
  #puts "res_arr: #{get_controller_name}_#{get_function_name}"
  #puts res_arr 

  return res_arr
end
