require "yard"
require "fileutils"

$controller_path = ARGV[0]
$view_path = ARGV[1]
$new_controller_path = ARGV[2]

def get_controller_name_from_path(filename)
	i = filename.rindex('/')
	j = filename.rindex("_controller.rb")
	if i == nil or j == nil
		return nil
	end
	n = filename[i+1..j-1]
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
		#puts item 
		a = item.split("=>")
		#puts a
		if a[0] == ':action' or a[0] == ':template' or a[0] == ':partial'
			#puts a[1]
			return a[1]
		end
	end
end

def traverse_routes_mapping(astnode, nested_path, controller_name)
	cur_astnode = astnode
	if cur_astnode == nil 
		return
	elsif cur_astnode.source.start_with?("def ") and not (cur_astnode.source.include?("render ") or cur_astnode.include?("render(") or cur_astnode.include?("redirect_to"))
		#puts cur_astnode.source 
		view_name = cur_astnode.source.split("\n")[0]
		view_name.gsub! "def ", ""
		view_name.gsub! " ", ""
		view_name.gsub! "\t", ""
		view_name.gsub! "\n", ""

		#puts "controller name: " + controller_name
		#puts "view name: " + view_name

		#puts view_name
		path = $view_path + nested_path + controller_name + "/_" + view_name + ".html.erb.rb"
		if !File.exist?(path)
			path = $view_path + nested_path + controller_name + "/" + view_name + ".html.erb.rb"
		end
		if !File.exist?(path)
			path = $view_path + nested_path + controller_name + "/_" + view_name + ".js.erb.rb"
		end
		if !File.exist?(path)
			path = $view_path + nested_path + controller_name + "/" + view_name + ".js.erb.rb"
		end
		if !File.exist?(path)
			#puts path
			return
		end
		view_file = File.open(path)
		view_contents = view_file.read

		if $layout_content != nil
			view_contents = $layout_content + view_contents
		end

		view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend\n"
		s = cur_astnode.source
		s.strip!
		lines = s.split("\n")
		puts lines
		lines_length = lines.length
		if lines[lines_length-1] == "e"
			lines_length -= 1
		end
		lines[lines_length] = lines[lines_length - 1]
		lines[lines_length - 1] = view_contents
		new_view_contents = lines.join("\n")
		# puts view_contents
		# puts new_view_contents

		#puts cur_astnode.source, new_view_contents
		if astnode.source.end_with?("\te") or astnode.source.end_with?("\ne") or astnode.source.end_with?(" e")
			$render_view_mapping[astnode.source[0..-3]] = new_view_contents
		else
			$render_view_mapping[cur_astnode.source] = new_view_contents
		end
		#render the default view
		#traverse_method_node(cur_astnode, base_path, controller_name)
	elsif (cur_astnode.source.start_with?("render ") or cur_astnode.source.start_with?("render(")) and (cur_astnode.type.to_s == "fcall" or cur_astnode.type.to_s == "command" or cur_astnode.type.to_s == "list")
		puts astnode.source
		astnode = cur_astnode
		template = parse_render_params(cur_astnode.source)
		template.gsub! ":", ""
		puts "template: " + template
		add_render_view(astnode, nested_path, controller_name, template)
	elsif cur_astnode.source.start_with?"render"
		puts cur_astnode.source
		puts cur_astnode.type.to_s
	else
		cur_astnode.children.each {|x| traverse_routes_mapping(x, nested_path, controller_name) }
	end
end

#
def add_render_view (astnode, nested_path, controller_name, view_name)
	view_name.gsub! "\"", ""
	view_name.gsub! "'", ""
	if view_name.include? '/'
		
		view_name = view_name.split('/')
		controller_name = view_name[0]
		view_name = view_name[1]
	end

	# puts "view_name: " + view_name

	# determine the view file location and name
	path = $view_path + nested_path + controller_name + "/_" + view_name + ".html.erb.rb"
	# puts astnode.source
	# puts path
	if !File.exist?(path)
		path = $view_path + nested_path + controller_name + "/" + view_name + ".html.erb.rb"
	end
	if !File.exist?(path)
		path = $view_path + nested_path + controller_name + "/_" + view_name + ".js.erb.rb"
	end
	if !File.exist?(path)
		path = $view_path + nested_path + controller_name + "/" + view_name + ".js.erb.rb"
	end
	if !File.exist?(path)
		return
	end



	view_file = File.open(path)
	view_contents = view_file.read
	
	if $layout_content != nil
		view_contents = $layout_content + view_contents
	end

	view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend\n"
	
	if astnode.parent.source.start_with?("return render")
		$render_view_mapping[astnode.parent.source] = view_contents
	elsif astnode.source.end_with?("\te") or astnode.source.end_with?("\ne") or astnode.source.end_with?(" e")
		$render_view_mapping[astnode.source[0..-3]] = view_contents
	else
		$render_view_mapping[astnode.source] = view_contents
	end

	view_file.close
end

def load_layout
	if File.exist? $view_path + "layouts/" + $layout + ".html.erb.rb"
		return File.open($view_path + "layouts/" + $layout + ".html.erb.rb").read
	elsif File.exist? $view_path + "layouts/application.html.erb.rb"
		return File.open($view_path + "layouts/application.html.erb.rb").read
	else 
		return nil
	end
end

def handle_single_file(item)

	controller_file = File.open(item, "r")
	controller_contents = controller_file.read


	controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

	controller_name = get_controller_name_from_path(item)
	$layout = controller_name
	$layout_content = load_layout
	nested_path = get_nested_path(item, $controller_path)
	
	#the render statement and the render view is a hash mapping
	$render_view_mapping = Hash.new
	traverse_routes_mapping(controller_ast, nested_path, controller_name)

	#replace all render statement by the view file 
	$render_view_mapping.each do |key, value|
	#	puts key
	#	puts value
		#puts controller_contents
		#puts key
		#puts controller_contents.include?(value)
		controller_contents.gsub! key, value
	end

	if not File.directory?($new_controller_path + nested_path)
		FileUtils.mkdir_p $new_controller_path + nested_path
	end
	File.write($new_controller_path + nested_path + controller_name + "_controller.rb", controller_contents)
	
	controller_file.close
end

def merge_controller_view
	Dir.glob($controller_path + "**/*") do |item|
		
		#read the controller file and parse it
		if not item.end_with?("_controller.rb")
			next
		end
		handle_single_file(item)
	end
end

merge_controller_view
#handle_single_file("controllers/activities_controller.rb")
