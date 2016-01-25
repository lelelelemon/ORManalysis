load "data_structure.rb"

def load_all_controllers(controller_path)
	controller_arr = Hash.new
	Dir.glob(controller_path + "**/*") do |item|
		next if not item.end_with?"_controller.rb"

		controller_arr[item] = Controller_Class.new(item)

	end

	controller_arr.each do |item_path, controller_class|
		controller_class.getFunctions.each do |k, v|
			puts "controller: " + controller_class.get_controller_name
			puts "action: " + k
			puts "redirect_to: "
			v.get_redirect_to_array.each do |redirect_to|
				puts redirect_to.source
			end

			puts "----------------------"
		end
	end
end

def load_all_views(view_path)
	view_hash = Hash.new
	Dir.glob(view_path + "**/*") do |item|
		next if not item.end_with?".erb"

		view_hash[item] = View_Class.new(item, view_path)
	end

	view_hash.each do |item_path, view_class|
		puts "view_path: " + item_path
		puts "controller: " + view_class.get_controller_name
		puts "view: " + view_class.get_view_name
		puts "hrefs: " + view_class.get_href_tags

		puts "forms: " + view_class.get_form_tags
		puts "form_for: "
		view_class.get_form_for_array.each do |form_for_tag|
			puts form_for_tag.source
		end

		puts "-------------------------"

	end	
end

#load_all_controllers("../app/controllers")
load_all_views "../app/views/"

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
#view_path = "../app/views/activities/index.html.erb"
#base_path = "../app/views";
#activities_index_view = View_Class.new(view_path, base_path)
#
#puts activities_index_view.getRBContent
#puts activities_index_view.getAst.source
#
#puts activities_index_view.getNestedPath
#puts activities_index_view.getControllerName
#puts activities_index_view.getViewName
