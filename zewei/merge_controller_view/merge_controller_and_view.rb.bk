require "yard"

# def traverse_method_node(astnode, base_path, controller_name)
# 	method_name astnode[1].source
# 	if !astnode.source.include? "render "

# 	end
# end


def traverse_routes_mapping(astnode, base_path, controller_name, default)
	cur_astnode = astnode
	if cur_astnode == nil 
		return
	elsif default == true && cur_astnode.source.start_with?("def ") && !cur_astnode.source.include?("render ")
		#puts cur_astnode.source 
		view_name = cur_astnode[0].source
		#puts view_name
		path = base_path + "/app/views/" + controller_name + "/_" + view_name + ".html.erb.rb"
		if !File.exist?(path)
			path = base_path + "/app/views/" + controller_name + "/" + view_name + ".html.erb.rb"
		end
		if !File.exist?(path)
			path = base_path + "/app/views/" + controller_name + "/_" + view_name + ".js.erb.rb"
		end
		if !File.exist?(path)
			path = base_path + "/app/views/" + controller_name + "/" + view_name + ".js.erb.rb"
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

		if cur_astnode[0].type == :string_literal
			add_render_view(astnode, base_path, controller_name, cur_astnode[0].source)
		else
			cur_astnode.children.each do |x|
				if x[0][0].source == ":partial" || x[0][0].source == ":action" || x[0][0].source == ":template"
					view_name = x[0][1].source
					add_render_view(astnode, base_path, controller_name, view_name)
				end
			end
		end
	else
		cur_astnode.children.each {|x| traverse_routes_mapping(x, base_path, controller_name, default) }
	end
end

#
def add_render_view (astnode, base_path, controller_name, view_name)
	view_name.gsub! "\"", ""
	view_name.gsub! "'", ""
	if view_name.include? '/'
		
		view_name = view_name.split('/')
		controller_name = view_name[0]
		view_name = view_name[1]
	end

	# puts "view_name: " + view_name

	# determine the view file location and name
	path = base_path + "/app/views/" + controller_name + "/_" + view_name + ".html.erb.rb"
	# puts astnode.source
	# puts path
	if !File.exist?(path)
		path = base_path + "/app/views/" + controller_name + "/" + view_name + ".html.erb.rb"
	end
	if !File.exist?(path)
		path = base_path + "/app/views/" + controller_name + "/_" + view_name + ".js.erb.rb"
	end
	if !File.exist?(path)
		path = base_path + "/app/views/" + controller_name + "/" + view_name + ".js.erb.rb"
	end
	if !File.exist?(path)
		return
	end



	view_file = File.open(path)
	view_contents = view_file.read
	
	if astnode.parent.source.start_with?("return")
		$render_view_mapping[astnode.parent.source] = view_contents
	else
		$render_view_mapping[astnode.source] = view_contents
	end
	view_file.close
end
#the base_path and the controller name should be passed in as parameters
base_path = ARGV[0]
controller_name = ARGV[1]


#read the controller file and parse it
controller_file = File.open(File.join(base_path, controller_name+"_controller.rb"), "r")
controller_contents = controller_file.read


controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

#the render statement and the render view is a hash mapping
$render_view_mapping = Hash.new
traverse_routes_mapping(controller_ast, base_path[0..-17], controller_name, true)

#replace all render statement by the view file 
$render_view_mapping.each do |key, value|
	controller_contents.gsub! key, value
end

#go for a second round to replace all renders inside view files
controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

#the render statement and the render view is a hash mapping
$render_view_mapping = Hash.new
traverse_routes_mapping(controller_ast, base_path[0..-17], controller_name, false)

#replace all render statement by the view file 
$render_view_mapping.each do |key, value|
	controller_contents.gsub! key, value
end

#the render statement and the render view is a hash mapping
$render_view_mapping = Hash.new
traverse_routes_mapping(controller_ast, base_path[0..-17], controller_name, false)

#replace all render statement by the view file 
$render_view_mapping.each do |key, value|
	controller_contents.gsub! key, value
end

# $render_view_mapping.each do |key, value|
# 	controller_contents.gsub! key, value
# end

#all render statement in controller content has been replaced by the embedded ruby code in the view file

puts controller_contents

controller_file.close
