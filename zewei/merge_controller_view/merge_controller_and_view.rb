require "yard"
require "fileutils"

$controller_path = ARGV[0]
$view_path = ARGV[1]
$new_controller_path = ARGV[2]

def get_controller_name_from_path(filename)
	puts "filename = #{filename}"
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

def traverse_routes_mapping(astnode, nested_path, controller_name, default)
	cur_astnode = astnode
	if cur_astnode == nil 
		return
	elsif default == true && cur_astnode.source.start_with?("def ") && !cur_astnode.source.include?("render ")
		#puts cur_astnode.source 
		view_name = cur_astnode[0].source
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
			return
		end
		view_file = File.open(path)
		view_contents = view_file.read

		lines = cur_astnode.source.split("\n")
		lines_length = lines.length
		lines[lines_length] = lines[lines_length - 1]
		lines[lines_length - 1] = view_contents
		new_view_contents = lines.join("\n")

		# puts view_contents
		# puts new_view_contents

		$render_view_mapping[cur_astnode.source] = new_view_contents
		#render the default view
		#traverse_method_node(cur_astnode, base_path, controller_name)
	elsif cur_astnode.source.start_with?("render ")
		#find the render ast node
		if cur_astnode[0].source == "render"
			cur_astnode = cur_astnode[1]
		else
			cur_astnode = cur_astnode[0][1]
		end	
		
		begin 
			if cur_astnode[0].type == :string_literal
				add_render_view(astnode, nested_path, controller_name, cur_astnode[0].source)
			else
				cur_astnode.children.each do |x|
					if x[0][0].respond_to?("source") && (x[0][0].source == ":partial" || x[0][0].source == ":action" || x[0][0].source == ":template")
						view_name = x[0][1].source
						add_render_view(astnode, nested_path, controller_name, view_name)
					end
				end
			end
		rescue
		end
	else
		cur_astnode.children.each {|x| traverse_routes_mapping(x, nested_path, controller_name, default) }
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

	view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend\n"
	
	if astnode.parent.source.start_with?("return render")
		$render_view_mapping[astnode.parent.source] = view_contents
	elsif astnode.source.end_with?("\te") or astnode.source.end_with?("\ne") or astnode.source.end_with?(" e")
		$render_view_mapping[astnode.source[0..-2]] = view_contents
	else
		$render_view_mapping[astnode.source] = view_contents
	end

	view_file.close
end


Dir.glob($controller_path + "**/*") do |item|
	puts item
	puts get_nested_path(item, $controller_path)


	#read the controller file and parse it
	if not item.end_with?("_controller.rb")
		next
	end
	controller_file = File.open(item, "r")
	controller_contents = controller_file.read


	controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

	controller_name = get_controller_name_from_path(item)
	nested_path = get_nested_path(item, $controller_path)
	
	#the render statement and the render view is a hash mapping
	$render_view_mapping = Hash.new
	traverse_routes_mapping(controller_ast, nested_path, controller_name, true)

	#replace all render statement by the view file 
	$render_view_mapping.each do |key, value|
	#	puts key
	#	puts value
		controller_contents.gsub! key, value
	end

	if not File.directory?($new_controller_path + nested_path)
		puts $new_controller_path + nested_path
		FileUtils.mkdir_p $new_controller_path + nested_path
	end
	
	File.write($new_controller_path + nested_path + controller_name + "_controller.rb", controller_contents)
	
	#go for a second round to replace all renders inside view files
	controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

	#the render statement and the render view is a hash mapping
	$render_view_mapping = Hash.new
	traverse_routes_mapping(controller_ast, nested_path, controller_name, false)

	#replace all render statement by the view file 
	$render_view_mapping.each do |key, value|
	#	puts key
	#	puts value
		controller_contents.gsub! key, value
	end

	if not File.directory?($new_controller_path + nested_path)
		puts $new_controller_path + nested_path
		FileUtils.mkdir_p $new_controller_path + nested_path
	end
	
	File.write($new_controller_path + nested_path + controller_name + "_controller.rb", controller_contents)
	
	#go for a second round to replace all renders inside view files
	controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

	#the render statement and the render view is a hash mapping
	$render_view_mapping = Hash.new
	traverse_routes_mapping(controller_ast, nested_path, controller_name, false)

	#replace all render statement by the view file 
	$render_view_mapping.each do |key, value|
	#	puts key
	#	puts value
		controller_contents.gsub! key, value
	end

	if not File.directory?($new_controller_path + nested_path)
		puts $new_controller_path + nested_path
		FileUtils.mkdir_p $new_controller_path + nested_path
	end

	File.write($new_controller_path + nested_path + controller_name + "_controller.rb", controller_contents)

	controller_file.close

end
