require "yard"
require "fileutils"

load "helper.rb"

$view_path = ARGV[0]
$new_view_path = ARGV[1]

def traverse_routes_mapping(astnode, nested_path, render_view_mapping, dep)
	cur_astnode = astnode
	if cur_astnode == nil 
		return
	elsif (cur_astnode.source.start_with?("render ") or cur_astnode.source.start_with?("render(")) and (cur_astnode.type.to_s == "fcall" or cur_astnode.type.to_s == "command" or cur_astnode.type.to_s == "list")
		astnode = cur_astnode
		template = parse_render_params(cur_astnode.source)
		add_render_view(astnode, nested_path, template, render_view_mapping, dep)
	elsif cur_astnode.source.start_with?"render"
		puts cur_astnode.source
		puts cur_astnode.type.to_s
	else
		cur_astnode.children.each {|x| traverse_routes_mapping(x, nested_path, render_view_mapping, dep) }
	end

end

def split_controller_view(controller_view)
	temp = controller_view.split "/"
	return temp[0], temp[1]
end

def pick_right_view_path(controller_name, view_name)
	if controller_name != ""
		path = $view_path + controller_name + "/_" + view_name + ".html.erb.rb"
	else	
		path = $view_path + "_" + view_name + ".html.erb.rb"
	end
	if !File.exist?(path)
		if controller_name != ""
			path = $view_path + controller_name + "/" + view_name + ".html.erb.rb"
		else
			path = $view_path + view_name + ".html.erb.rb"
		end
	end
	if !File.exist?(path)
		if controller_name != ""
			path = $view_path + controller_name + "/_" + view_name + ".js.erb.rb"
		else
			path = $view_path + "_" + view_name + ".js.erb.rb"
		end
	end
	if !File.exist?(path)
		if controller_name != ""
			path = $view_path + controller_name + "/" + view_name + ".js.erb.rb"
		else
			path = $view_path + view_name + ".js.erb.rb"
		end
	end
	if !File.exist?(path)
		path = nil
		#puts $view_path
	end
	return path
end

def add_render_view (astnode, nested_path, view_name, render_view_mapping, dep)
	view_name = view_name.to_s
	if view_name.start_with?"/"
		view_name = view_name[1..-1]
	end
	view_name.gsub! /"' \t\n/, ""
	view_name.gsub! ".html.erb", ""
	controller_name = nested_path[0..-2]
	if view_name.include? '/'
		controller_name, view_name = split_controller_view(view_name)
	end
	
	# determine the view file location and name

	#view_file = File.open(path)

	path = pick_right_view_path(controller_name, view_name)
	return if path == nil
	view_contents = handle_single_file(path, dep+1)

	view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend\n"
	
	#puts astnode.source

	if astnode.parent.source.start_with?("return render")
		render_view_mapping[astnode.parent.source] = view_contents
	elsif astnode.source.end_with?("\te") or astnode.source.end_with?("\ne") or astnode.source.end_with?(" e")
		render_view_mapping[astnode.source[0..-3]] = view_contents
	else
		render_view_mapping[astnode.source] = view_contents
	end
end

def handle_single_file(item, dep)

	view_file = File.open(item, "r")
	view_contents = view_file.read
	nested_path = get_nested_path(item, $view_path)
	filename = get_filename_from_path(item)
	view_file.close
	#while view_contents.include?"render" and i < 10
		
	File.write("log2.txt", view_contents + "\n" + item)
	if dep < 10
		view_ast = YARD::Parser::Ruby::RubyParser.parse(view_contents).root

		
		#the render statement and the render view is a hash mapping
		render_view_mapping = Hash.new
	
		traverse_routes_mapping(view_ast, nested_path, render_view_mapping, dep)

		#replace all render statement by the view file 
		render_view_mapping.each do |key, value|
			puts view_contents
			puts key
			puts view_contents.include?key
	#		puts key, value
			view_contents.gsub! key, value
		end
		puts view_contents
	#end
	end
	
	puts view_contents
	return view_contents

end

def replace_render_stmt
	Dir.glob($view_path + "**/*") do |item|
		if not item.end_with?(".erb.rb")
			next
		end
		view_contents = handle_single_file(item, 0)

		nested_path = get_nested_path(item, $view_path)
		filename = get_filename_from_path(item)
		if not File.directory?($new_view_path + nested_path)
			FileUtils.mkdir_p $new_view_path + nested_path
		end

		File.write($new_view_path + nested_path + filename, view_contents)

	end
end

replace_render_stmt
#handle_single_file("views/news_items/edit.html.erb.rb", 0)
