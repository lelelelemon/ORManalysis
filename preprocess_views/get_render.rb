class Controller
	def initialize(fname, cname)
		@file_name = fname
		@controller_name = cname
		#Here they are default renders
		@render_stmts = Array.new
		#puts "Find new class #{cname}"
		@upper_class = nil
		@actions = Array.new
	end
	attr_accessor :controller_name, :render_stmts, :upper_class, :actions
	def get_layout_render
		controller_path = get_controller_downcase(@controller_name).split("::")
		controller_path = controller_path.join("/")
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/layouts/#{controller_path}.html.erb"
		exist = File.exist?(file_path)
		if exist
			puts "#{@controller_name}: Default layout path = #{file_path}"
			rnder = Render_stmt.new(self, nil)
			rnder.is_layout = true
		end
	end
	def find_layout(layout_name)
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/layouts/#{layout_name}.html.erb"
		exist = File.exist?(file_path)
		if exist
			puts "#{@controller_name}: Defined layout path = #{file_path}"
			rnder = Render_stmt.new(self, nil)
			rnder.is_layout = true
		end
	end
	def exist_layout
		@render_stmts.each do |r|
			if r.is_layout
				return true
			end
		end
		return false
	end
	def get_layout
		@render_stmts.each do |r|
			if r.is_layout
				return r
			end
		end
		return nil
	end
end

class Action
	def initialize(controller, aname)
		@render_stmts = Array.new
		@controller = controller
		controller.actions.push(self)
		@action_name = aname
		#puts "Find new action #{controller.controller_name}.#{aname}"
	end
	attr_accessor :render_stmts, :action_name, :controller
	def get_default_render
		controller_path = get_controller_downcase(@controller.controller_name).split("::")
		controller_path = controller_path.join("/")
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/#{controller_path}/#{@action_name}.html.erb"
		exist = File.exist?(file_path)
		if exist
			#puts "default render path = #{file_path}, exist = #{exist}"
			rnder = Render_stmt.new(self, nil)
			rnder.is_default = true
		end
	end
	def exist_template
		@render_stmts.each do |r|
			if r.is_default
				return true
			end	
		end
		return false
	end
	def get_template
		@render_stmts.each do |r|
			if r.is_default
				return r
			end
		end
		return nil
	end
end

class View_file
	def initialize(file_path)
		@file_path = file_path
		@render_stmts = Array.new
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
	attr_accessor :render_stmts, :file_path
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
	attr_accessor :is_default, :is_layout, :astnode, :action
	def parse_render
	end
end

