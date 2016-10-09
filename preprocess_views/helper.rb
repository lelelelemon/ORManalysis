def get_class_name_from_class_node(node)
	if node.children[0].type.to_s == "const_path_ref" or node.children[0].type.to_s == "const_ref"
		return node.children[0].source.to_s
	else
		return get_left_most_leaf(node).source.to_s
	end
end

def class_includes_functions(astnode)
	if astnode.class.to_s == "YARD::Parser::Ruby::MethodDefinitionNode"
		return true
	elsif astnode.type.to_s == "class" or astnode.type.to_s == "module"
	else
		r = false
		astnode.children.each do |child|
			if class_includes_functions(child)
				r = true
			end
		end
		return r
	end 
end

#Input: ProjectsController
#Output: projects
#Input: My::ProjectsController
#Output: my::projects 
def get_controller_downcase(controller_name)
	return controller_name.downcase.gsub("controller","")	
end
