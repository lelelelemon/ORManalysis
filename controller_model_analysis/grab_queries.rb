def traverse_ast(astnode, level)
	astnode.children.each do |child|
		traverse_ast(child, level+1)
	end
end

