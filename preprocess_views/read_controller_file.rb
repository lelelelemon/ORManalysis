require 'yard'

def read_controller_files
	root, files, dirs = os_walk($controller_dir)
	for filename in files
		if filename.to_s.end_with?(".rb")
			fp = File.open(filename.to_s, "r")
			contents = fp.read
			ast = YARD::Parser::Ruby::RubyParser.parse(contents).root
			@class_stack = Array.new
			recursive_get_class_stack(ast, @class_stack, filename)
		end
	end
end

def recursive_get_class_stack(astnode, class_stack, filename)
	if astnode.is_a?YARD::Parser::Ruby::AstNode
		if astnode.type.to_s == "class" or astnode.type.to_s == "module"
			class_stack.push(astnode)
			@class_name = ""
			for i in 0...class_stack.length-1
				@class_name += "#{get_class_name_from_class_node(class_stack[i])}::"
			end
			@class_name += "#{get_class_name_from_class_node(class_stack[-1])}"
			@include_function = false
			@has_sub = false
			astnode.children.each do |child|
				@has_subclass = false
				if child.type.to_s == "list"
					child.children.each do |c|
						if c.type.to_s == "class" or c.type.to_s == "module"
							@has_subclass = true
						end
					end
				end
				if class_includes_functions(child)
					@include_function = true
				end
				if @has_subclass
					@has_sub = true
					#read_each_class(@class_name, astnode, filename)
					recursive_get_class_stack(child, class_stack, filename)
				end
			end
			if (@has_sub and @include_function) or @has_sub == false
				read_each_class(@class_name, astnode, filename)
			else
				#puts "#{@class_name} is not read!!! #{@has_sub} #{@include_function}"
			end
			class_stack.pop
		else
			astnode.each do |child|
				recursive_get_class_stack(child, class_stack, filename)
			end
		end 
	end
end

def read_each_class(class_name, class_node, filename)
	cur_controller = Controller.new(filename, class_name)
	$controllers[class_name] = cur_controller
	$cur_controller = cur_controller
	level = 0
	traverse_ast(class_node, level)
end

def traverse_ast(astnode, level)
	if astnode.class.to_s == "YARD::Parser::Ruby::MethodDefinitionNode"
		@method_name = astnode.children[0].source.to_s
		if @method_name == "self"
			@method_name = astnode.children[2].source.to_s
		end
		$cur_action = Action.new($cur_controller, @method_name)
		$cur_action.get_default_render
		$actions[@method_name] = $cur_action
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
	elsif astnode.class.to_s == "YARD::Parser::Ruby::MethodCallNode"
		if astnode.children[0].source == "render"
			puts "In #{$cur_controller.controller_name}.#{$cur_action.action_name}"
			puts "\tFind render stmt: #{astnode.source}"
			#render stmt
			rnder = Render_stmt.new($cur_action, astnode)
			rnder.parse_render
		else
			astnode.children.each do |child|
				traverse_ast(child, level+1)
			end
		end
	elsif astnode.class.to_s != "Symbol"
		astnode.children.each do |child|
			traverse_ast(child, level+1)
		end
	end
end
