class BaseStructure
	def initialize
		@render_stmts = Array.new
		@use_layout = true
	end
	attr_accessor :render_stmts, :use_layout
end

class Controller < BaseStructure
	def initialize(fname, cname)
		super()
		@file_name = fname
		@controller_name = cname
		#Here they are default renders
		#puts "Find new class #{cname}"
		@upper_class = nil
		@actions = Array.new
	end
	attr_accessor :controller_name, :upper_class, :actions
	def get_layout_render
		controller_path = get_controller_downcase(@controller_name).split("::")
		controller_path = controller_path.join("/")
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/layouts/#{controller_path}.html.erb"
		exist = File.exist?(file_path)
		if exist
			puts "#{@controller_name}: Default layout path = #{file_path}"
			rnder = Render_stmt.new(self, nil, file_path)
			rnder.is_layout = true
		end
	end
	def find_layout(layout_name)
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/layouts/#{layout_name}.html.erb"
		exist = File.exist?(file_path)
		if exist
			#puts "#{@controller_name}: Defined layout path = #{file_path}"
			rnder = Render_stmt.new(self, nil, file_path)
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

class Action < BaseStructure
	def initialize(controller, aname)
		super()
		@controller = controller
		controller.actions.push(self)
		@action_name = aname
		#puts "Find new action #{controller.controller_name}.#{aname}"
	end
	attr_accessor :action_name, :controller
	def get_default_render
		controller_path = get_controller_downcase(@controller.controller_name).split("::")
		controller_path = controller_path.join("/")
		file_path = "#{$path_prefix}/#{$new_view_folder_name}/#{controller_path}/#{@action_name}.html.erb"
		exist = File.exist?(file_path)
		if exist
			#puts "default render path = #{file_path}, exist = #{exist}"
			rnder = Render_stmt.new(self, nil, file_path)
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

class View_file < BaseStructure
	def initialize(file_path)
		super()
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
	attr_accessor :file_path, :controller, :action
end

$render_key_words=["ident","tstring_content","kw", "int"]
class Render_stmt
	def initialize(action, astnode, file_path="")
		#type of action can be: Controller, Action, View_file
		@action = action
		action.render_stmts.push(self)
		@render_file = file_path
		@is_default = false
		@is_layout = false
		@astnode = astnode
		@properties = Hash.new
		self.parse_render
	end
	attr_accessor :is_default, :is_layout, :astnode, :action, :render_file
	def parse_render
		if @astnode == nil
			return
		end
		set_layout = false
		$node_stack = Array.new
		recursive_parse_render(@astnode, $render_key_words)
		#if @action.instance_of?Action
		#	print "#{@action.controller.controller_name}.#{@action.action_name}:"
		#end
		#puts "parse render: #{@astnode.source} (#{$node_stack.length})"
		state = 0
		str = "\t"
		hash_key = ""
		$node_stack.each do |n|
			if state == 0 and n.type.to_s == "ident"
				str += "), (#{n.source} =>"
				hash_key = n.source
				state = 1
			elsif state == 1
				str += " #{n.source} "
				@properties[hash_key] = n.source
				state = 0
			end
		end
		#puts str	
		@properties.each do |k,v|
			if k == "partial" or k == "template" or k == "action"
				controller_name = ""
				if @action.instance_of?Action
					controller_name = get_controller_downcase(@action.controller.controller_name).gsub("::","/")
				elsif @action.instance_of?View_file
					controller_name = @action.controller.gsub("::","/")
				end
				file_path = ""
				if v.include?'/'
					chs = v.split('/')
					if k == "partial"
						file_path ="#{$path_prefix}/#{$new_view_folder_name}/#{chs[0...-1].join("/")}/_#{chs[-1]}.html.erb" 
					else
						file_path ="#{$path_prefix}/#{$new_view_folder_name}/#{chs[0...-1].join("/")}/#{chs[-1]}.html.erb"
					end
				else
					if k == "partial"
						file_path = "#{$path_prefix}/#{$new_view_folder_name}/#{controller_name}/_#{v}.html.erb" 
					else
						file_path = "#{$path_prefix}/#{$new_view_folder_name}/#{controller_name}/#{v}.html.erb" 
					end
				end
				exist = File.exist?(file_path)
				if exist
					@render_file = file_path	
				end
			elsif k == "layout"
				if v == "false"
					@action.use_layout = false
					set_layout = true
				else
					file_path = "#{$path_prefix}/#{$new_view_folder_name}/layouts/#{v}.html.erb"
					if File.exist?(file_path)
						@render_file = file_path
						@is_layout = true
					end
				end
			end
		end
		#debug
		if @render_file.length == 0 and @astnode and set_layout == false
			str = "Empty render -> "
			if @action.instance_of?Action
				str += "#{@action.controller.controller_name}.#{@action.action_name}: "
			elsif @action.instance_of?View_file
				str += "#{@action.file_path}: "
			end
			str += "#{@astnode.source.to_s}"
			puts str
		end
	end
end

