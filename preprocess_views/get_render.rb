
class Controller
	def initialize(fname, cname)
		@file_name = fname
		@controller_name = cname
		#puts "Find new class #{cname}"
	end
	attr_accessor :controller_name
end

class Action
	def initialize(controller, aname)
		@render_stmts = Array.new
		@controller = controller
		@action_name = aname
		#puts "Find new action #{controller.controller_name}.#{aname}"
	end
	attr_accessor :render_stmts, :action_name
	def get_default_render
		controller_path = get_controller_downcase(@controller.controller_name).split("::")
		controller_path = controller_path.join("/")
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/#{controller_path}/#{@action_name}.html.erb"
		exist = $view_files.has_key?file_path
		puts "default render path = #{file_path}"
	end

end

class View_file
	def initialize(file_path)
		@file_path = file_path
		state = 0
		@controller = ""
		@action = ""
		words = file_path.split("/")
		words.each do |p|
			if p == $new_view_folder_name
				state = 1
			elsif state == 1
				@controller = p
				break	
			end
		end
		state = 0
		file_path.split("/").reverse.each do |p|
			if state == 0
				@action = p.gsub(".html.erb","")
				state = 1
			elsif state == 1
				if p != @controller
					@controller += "::#{p}"
					if File.directory?(words[0...-2].join('/'))
					else
						run_command("mkdir #{words[0...-2].join('/')}")
					end
				end
				break
			end
		end
		if File.directory?(words[0...-1].join('/'))
		else
			run_command("mkdir #{words[0...-1].join('/')}")
		end
		#puts "\tcontroller = #{@controller}, action = #{@action}"
	end
end

class Render_stmt
	def initialize(action, astnode)
		@action = action
		action.render_stmts.push(self)
		@render_file = ""
		@is_default = false
		@is_layout = false
		@astnode = astnode
	end
	def parse_render
	end
end

