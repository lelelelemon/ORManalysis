def solve_all_renders
	$actions.each do |k, a|
		if a.is_entrance or a.has_non_default_or_layout_render
			solve_render_for_action(a)
			puts "Action: #{a.controller.name}.#{a.name} renders:"
			a.render_stack.each do |r|
				puts "\t#{r.render_file}"
			end
		end
	end
end

def solve_render_for_action(action)
	#first, check layout
	if action.use_layout and action.controller.exist_layout
		action.push_to_render_stack(action.controller.get_layout)
	end	
	#then check render stmt
	exist_render = false
	action.render_stmts.each do |r|
		if r.valid_file_path
			action.push_to_render_stack(r)
			exist_render = true
			solve_render_for_view(action, r.render_file)
		end
	end
	#if no exist render, check default render
	if exist_render == false
		if action.exist_template
			action.push_to_render_stack(action.get_template)
		end
	end
end

#recursively...
def solve_render_for_view(action, view_file)
	viewf = find_view_file(view_file)
	if viewf
		viewf.render_stmts.each do |r|
			if r.valid_file_path
				exist = action.push_to_render_stack(r)
				if exist == false
					solve_render_for_view(action, r.render_file)
				end
			end
		end
	end
end
