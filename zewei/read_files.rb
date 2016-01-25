load "data_structure.rb"

#path = "../app/controllers/users_controller.rb"
#
#users_controller = Controller_Class.new(path)
#
#puts users_controller
##puts users_controller.getContent
##puts users_controller.getAst.source
#users_controller.getFunctions.each do |k, v|
#	puts "key: " + k
#	v.get_render_array.each do |x|
#		puts "source: " + x.source
#		puts "type: " + x.type.to_s
#	end
#end
#
view_path = "../app/views/activities/index.html.erb"
base_path = "../app/views";
activities_index_view = View_Class.new(view_path, base_path)

puts activities_index_view.getRBContent
puts activities_index_view.getAst.source

puts activities_index_view.getNestedPath
puts activities_index_view.getControllerName
puts activities_index_view.getViewName
