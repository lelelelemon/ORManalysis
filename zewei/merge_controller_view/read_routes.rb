require "YARD"

def traverse_routes_mapping(astnode)
	# puts astnode
	if astnode.source.start_with?("resources")
		#TODO: handle resources

	elsif astnode.source.start_with?("get") && astnode.type == :command
		astnode = astnode[1][0]
		#puts astnode.source
		pattern = astnode[0][0].source
		controller_function = astnode[0][1].source
		$routes_mapping[pattern] = controller_function
		for i in 1..astnode.children.length-1
			if astnode.children[i][0].source == ":as"
				#TODO: handle the case of alias here
				$routes_mapping[astnode.children[i][1].source] = controller_function
			end
		end
	elsif astnode.source.start_with?("post") && astnode.type == :command
		astnode = astnode[1][0]
		#puts astnode.source
		pattern = astnode[0][0].source
		if astnode[0].type == :assoc
			controller_function = astnode[0][1].source
			$routes_mapping[pattern] = controller_function
			for i in 1..astnode.children.length-1
				if astnode.children[i][0].source == ":as"
					#TODO: handle the case of alias here
					$routes_mapping[astnode.children[i][1].source] = controller_function
				end
			end
		end
	else
		astnode.children.each {|x| traverse_routes_mapping(x)}
	end
end

base_path = "C:\\Users\\jasonchuzewei\\Desktop\\DB_Performance_Proj\\play"
project_name = "lobsters"

routes_file = File.open(base_path + "\\" + project_name + "\\config\\routes.rb", "r")
routes_contents = routes_file.read
ast = YARD::Parser::Ruby::RubyParser.parse(routes_contents).root
$routes_mapping = Hash.new
traverse_routes_mapping(ast)
#puts $routes_mapping

File.open(base_path + "\\href.txt", "r") do |f|
  f.each_line do |line|
    line.gsub!(/<%=(.+?)%>/m, '')
    line.gsub!(/\n/, '')
    #puts line
    $routes_mapping.keys.each{ |x| 
    	if x.include?(line)
    		puts line + ": " + x + " => " + $routes_mapping[x]
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
