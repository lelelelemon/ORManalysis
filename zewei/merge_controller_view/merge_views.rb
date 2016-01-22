require "yard"
require "fileutils"

$view_path = ARGV[0]
$new_view_path = ARGV[1]

def get_filename_from_path(filename)
	i = filename.rindex('/')
	if i == nil
		return nil
	end
	n = filename[i+1..-1]
	return n
end

def get_nested_path(filepath, basepath)
	i = filepath.rindex(basepath)
	j = filepath.rindex('/')
	if i == nil or j == nil
		return nil
	end
	n = filepath[i+basepath.length..j]
	return n
end

def parse_render_params(line)

	line = line.to_s	
	line.gsub! "render", ""
	line.gsub! "\"", ""
	line.gsub! "'", ""
	line.gsub! " ", ""
	line.gsub! "\t", ""
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
		puts item 
		a = item.split("=>")
		puts a
		if a[0] == ':action' or a[0] == ':template' or a[0] == ':partial'
			puts a[1]
			return a[1]
		end
	end

end

def traverse_routes_mapping2(astnode, nested_path)
	cur_astnode = astnode
	if cur_astnode == nil 
		return
	elsif (cur_astnode.source.start_with?("render ") or cur_astnode.source.start_with?("render(")) and (cur_astnode.type.to_s == "fcall" or cur_astnode.type.to_s == "command" or cur_astnode.type.to_s == "list")
		astnode = cur_astnode

		puts cur_astnode.source	
		template = parse_render_params(cur_astnode.source)
		add_render_view(astnode, nested_path, template)
	elsif cur_astnode.source.start_with?"render"
		#puts cur_astnode.source
		#puts cur_astnode.type.to_s
	else
		cur_astnode.children.each {|x| traverse_routes_mapping2(x, nested_path) }
	end
end

def add_render_view (astnode, nested_path, view_name)
	view_name = view_name.to_s
	if view_name.start_with?"/"
		view_name = view_name[1..-1]
	end
	view_name.gsub! "\"", ""
	view_name.gsub! "'", ""
	view_name.gsub! " ", ""
	view_name.gsub! ".html.erb", ""
	controller_name = nested_path[0..-2]
	if view_name.include? '/'
		
		view_name = view_name.split('/')
		controller_name = view_name[0]
		view_name = view_name[1]
	end
	
	puts controller_name
	puts view_name

	# determine the view file location and name
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
		#puts path
		#puts $view_path
		return
	end



	view_file = File.open(path)
	view_contents = view_file.read

	view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend\n"
	
	#puts astnode.source

	if astnode.parent.source.start_with?("return render")
		$render_view_mapping[astnode.parent.source] = view_contents
	elsif astnode.source.end_with?("\te") or astnode.source.end_with?("\ne") or astnode.source.end_with?(" e")
		$render_view_mapping[astnode.source[0..-2]] = view_contents
	else
		$render_view_mapping[astnode.source] = view_contents
	end

	view_file.close
end

def handle_single_file(item)

	view_file = File.open(item, "r")
	view_contents = view_file.read
	nested_path = get_nested_path(item, $view_path)
	filename = get_filename_from_path(item)
	view_file.close
	i = 0
	while view_contents.include?"render" and i < 10
		
		File.write("log2.txt", view_contents + "\n" + item)
		view_ast = YARD::Parser::Ruby::RubyParser.parse(view_contents).root

		
		#the render statement and the render view is a hash mapping
		$render_view_mapping = Hash.new
		traverse_routes_mapping2(view_ast, nested_path)

		#replace all render statement by the view file 
		$render_view_mapping.each do |key, value|
	#		puts key, value
			view_contents.gsub! key, value
		end
		i += 1
	end
	
	if not File.directory?($new_view_path + nested_path)
		FileUtils.mkdir_p $new_view_path + nested_path
	end

	File.write($new_view_path + nested_path + filename, view_contents)

end

def replace_render_stmt
	Dir.glob($view_path + "**/*") do |item|
		if not item.end_with?(".erb.rb")
			next
		end
		handle_single_file(item)

	end
end

replace_render_stmt
#handle_single_file("views/customers/edit.html.erb.rb")
