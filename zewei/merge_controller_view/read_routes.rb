require "yard"
require "fileutils"

$URL_pattern_keys = Array.new

def traverse_routes_mapping(astnode)
	# puts astnode
	if astnode.source.start_with?("resources")
		#TODO: handle resources
		view_name = astnode[1].source
		while view_name[0] == ':'
			view_name = view_name[1..-1]
		end
 		#puts view_name
		childnode = astnode[2][1]
		if childnode.source.start_with?"member"
			#puts "member method"
		else 
			#TODO: handle all 7 cases, differentiate POST and GET

			#index			
			pattern = "GET /" + view_name + ""
			controller_function = view_name + "#index"
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function


			pattern = "GET /" + view_name + "/new"
			controller_function = view_name + "#new"
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function

			pattern = "POST /" + view_name
			controller_function = view_name + "#create"
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function

			pattern = "GET /" + view_name + "/"
			controller_function = view_name + "#show"
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function

			# pattern = "GET /" + view_name + "/"
			# controller_function = view_name + "#edit"
			# $URL_pattern_keys.push(pattern)
			# $routes_mapping[pattern] = controller_function

			# pattern = "/" + view_name + "/"
			# controller_function = view_name + "#update"
			# $URL_pattern_keys.push(pattern)
			# $routes_mapping[pattern] = controller_function

			pattern = "DELETE /" + view_name + "/"
			controller_function = view_name + "#destroy"
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function

			childnode.each do |x|
				#puts x.source
			end
		end

	elsif astnode.source.start_with?("get") && astnode.type == :command
		astnode = astnode[1][0]
		#puts astnode.source
		pattern = astnode[0][0].source
		pattern.gsub!(/\"/, '')
		pattern = "GET " + pattern

		controller_function = astnode[0][1].source
		$URL_pattern_keys.push(pattern)
		$routes_mapping[pattern] = controller_function
		for i in 1..astnode.children.length-1
			if astnode.children[i][0].source == ":as"
				#TODO: handle the case of alias here
			
				pattern = astnode.children[i][1].source
				pattern.gsub!(/\"/, '')
				pattern = "GET " + pattern

				$URL_pattern_keys.push(pattern)
				$routes_mapping[pattern] = controller_function
			end
		end
	elsif astnode.source.start_with?("post") && astnode.type == :command
		astnode = astnode[1][0]
		#puts astnode.source
		pattern = astnode[0][0].source
		pattern.gsub!(/\"/, '')
		pattern = "POST " + pattern

		if astnode[0].type == :assoc
			controller_function = astnode[0][1].source
			$URL_pattern_keys.push(pattern)
			$routes_mapping[pattern] = controller_function
			for i in 1..astnode.children.length-1
				if astnode.children[i][0].source == ":as"
					#TODO: handle the case of alias here
					pattern = astnode.children[i][1].source
					pattern.gsub!(/\"/, '')
					pattern = "POST " + pattern

					$URL_pattern_keys.push(pattern)
					$routes_mapping[pattern] = controller_function
				end
			end
		end
	else
		astnode.children.each {|x| traverse_routes_mapping(x)}
	end
end

base_path = Dir.pwd
project_name = ARGV[0]

routes_file = File.open(base_path + "/" + project_name + "/config/routes.rb", "r")
routes_contents = routes_file.read
ast = YARD::Parser::Ruby::RubyParser.parse(routes_contents).root
$routes_mapping = Hash.new
traverse_routes_mapping(ast)
#puts $routes_mapping
#puts $URL_pattern_keys

File.open(base_path + "/href.txt", "r") do |f|
  f.each_line do |line|
    line.gsub!(/<%=(.+?)%>/m, '')
    line.gsub!(/\n/, '')
    line.gsub!(/ /, '')
    line.strip!

    $URL_pattern_keys.each{ |x|
    	if x.include?line
#		puts line
    		puts line + ": " + x + " => " + $routes_mapping[x]
		break  
  	end
    }
  end
end

# erb_rb_filename = ""

# file = File.open(in_filename, "r")
# contents = file.read
# ast = YARD::Parser::Ruby::RubyParser.parse(contents).root

# def traverse_ast_variables(astnode, variable_array, out)
# 	if astnode.source.start_with?("form_")
# 		out << astnode.source + "\n\n"
# 	else 
# 		astnode.children.each do |child|
# 			traverse_ast_variables(child, variable_array, out)
# 		end
# 	end
# end

# out = File.open(out_filename, "w")
# traverse_ast_variables(ast, variable_array, out)


# routes_file.close
