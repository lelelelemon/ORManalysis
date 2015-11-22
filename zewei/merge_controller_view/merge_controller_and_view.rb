require "YARD"

def traverse_routes_mapping(astnode, base_path, controller_name)

	cur_astnode = astnode

	if cur_astnode == nil 
		return
	elsif cur_astnode.source.start_with?("render ")

		#find the render ast node
		if cur_astnode[0].source == "render"
			cur_astnode = cur_astnode[1]
		else
			cur_astnode = cur_astnode[0][1]
		end
		
		cur_astnode.children.each do |x|

			if x[0][0].source == ":partial" || x[0][0].source == ":action" || x[0][0].source == ":template"

				view_name = x[0][1].source
				puts "view_name before #{view_name}"
				if view_name.include? '/'
					view_name.gsub! "\"", ""
					view_name = view_name.split('/')
					controller_name = view_name[0]
					view_name = view_name[1]
				end

				view_name = view_name.delete('"')
				puts "view_name after #{view_name}"
				

				# determine the view file location and name
				path = base_path + "/app/views/" + controller_name + "/_" + view_name + ".html.erb.rb"

				puts "path = #{path}"
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
				puts "path = #{path}"
				view_contents = view_file.read
				
				if astnode.parent.source.start_with?("return")
					$render_view_mapping[astnode.parent.source] = view_contents
				else
					$render_view_mapping[astnode.source] = view_contents
				end
				view_file.close
			end
		end

	else
		cur_astnode.children.each {|x| traverse_routes_mapping(x, base_path, controller_name) }
	end
end

#the base_path and the controller name should be passed in as parameters
base_path = "../../..//lobsters"
controller_name = "comments"

#read the controller file and parse it
controller_file = File.open(base_path + "/app//controllers/" + controller_name + "_controller.rb", "r")
controller_contents = controller_file.read
controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_contents).root

#the render statement and the render view is a hash mapping
$render_view_mapping = Hash.new
traverse_routes_mapping(controller_ast, base_path, controller_name)

#replace all render statement by the view file 
$render_view_mapping.each do |key, value|
	controller_contents.gsub! key, value
end

#all render statement in controller content has been replaced by the embedded ruby code in the view file
puts controller_contents

controller_file.close
