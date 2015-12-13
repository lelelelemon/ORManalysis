require 'yard'
#the base_path and the controller name should be passed in as parameters
$base_path = "../../applications/boxroom"
$rb_view_name = "view_rb"

def get_controller_name_from_path(filename)
	i = filename.rindex('/')
	j = filename.rindex("_controller.rb")
	n = filename[i+1..j-1]
	return n
end

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

		#TODO: How to handle nil node here??
		if cur_astnode == nil
			return
		end	
		cur_astnode.children.each do |x|

			if x[0][0].source == ":partial" || x[0][0].source == ":action" || x[0][0].source == ":template"

				view_name = x[0][1].source
				if view_name.include? '/'
					view_name.gsub! "\"", ""
					view_name = view_name.split('/')
					controller_name = view_name[0]
					view_name = view_name[1]
				end

				view_name = view_name.delete("\"").delete("\'")
				puts "view_name = #{view_name}"
				#TODO: previously it was ".html.erb.rb", why .rb?
				# determine the view file location and name
				path = base_path + "/#{$rb_view_name}/" + controller_name + "/_" + view_name + ".html.erb"
				if !File.exist?(path)
					path = base_path + "/#{$rb_view_name}/" + controller_name + "/" + view_name + ".html.erb"
				end
				if !File.exist?(path)
					path = base_path + "/#{$rb_view_name}/" + controller_name + "/_" + view_name + ".js.erb"
				end
				if !File.exist?(path)
					path = base_path + "/#{$rb_view_name}/" + controller_name + "/" + view_name + ".js.erb"
				end
				if !File.exist?(path)
					return
				end

				view_file = File.open(path)
				view_contents = view_file.read

				puts "view_file = #{path}"

				view_contents = "ruby_code_from_view.ruby_code_from_view do |rb_from_view| \n#{view_contents}\nend"				

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

$controller_files = "#{$base_path}/controllers/*.rb"
$new_controller_dir = "#{$base_path}/merged_controllers/"

Dir.glob($controller_files) do |item|
	next if item == '.' or item == '..'
	
	controller_file = File.open(item, "r")
	controller_content = controller_file.read
	controller_ast = YARD::Parser::Ruby::RubyParser.parse(controller_content).root
	#the render statement and the render view is a hash mapping
	$render_view_mapping = Hash.new
	controller_name = get_controller_name_from_path(item)
	puts "Running controller: #{controller_name}"
	
	traverse_routes_mapping(controller_ast, $base_path, controller_name)
	
	#replace all render statement by the view file 
	$render_view_mapping.each do 	|key, value|
		controller_content.gsub! key, value
	end
	
	output_file_name = "#{$new_controller_dir}/#{controller_name}_controller.rb"
	output_file = File.open(output_file_name, "w")
	output_file.write(controller_content)

	controller_file.close
	output_file.close

end

