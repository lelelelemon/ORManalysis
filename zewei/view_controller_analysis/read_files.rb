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

def print_href_tags(tag_arr, named_routes_class)
	res = "route = Rails.application.routes\n"
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				puts "controller: " + v[0] + ", action: " + v[1]
				url_inside = true
			end
		end
		if not url_inside
			tag2 = tag + ""
			tag.gsub! /<%.*%>/, "2"
			res += ("route.recognize_path '" + tag + "' #" + tag2 + "\n")
		end
	end

	File.write("temp.rb", res)

	system("rails console < temp.rb > temp2.txt")
	res = ""
	File.readlines("temp2.txt").each do |line|
		if line.start_with?"{" or line.start_with?"route.recognize"
			res += line
		end
	end
	puts res
end


def load_all_views(view_path)
	named_routes_path = "named_routes.txt"
	named_routes_class = Named_Routes_Class.new(named_routes_path)
	#puts named_routes_class.get_named_routes
	
	view_hash = Hash.new
	Dir.glob(view_path + "**/*") do |item|
		next if not item.end_with?".erb"

		view_hash[item] = View_Class.new(item, view_path)
	end

#	view_hash["/home/osboxes/ORM/lobsters/app/views/layouts/application.html.erb"] = View_Class.new("/home/osboxes/ORM/lobsters/app/views/layouts/application.html.erb", view_path)

	indent = "---"

	view_hash.each do |item_path, view_class|
		puts indent + "view_path: " + item_path
		puts indent + "controller: " + view_class.get_controller_name
		puts indent + "view: " + view_class.get_view_name

		# get html tags
		puts indent + "hrefs: "# + view_class.get_href_tags
		print_href_tags(view_class.get_href_tag_array_from_html, named_routes_class)
#		print_rails_tag(view_class.get_href_tag_array_from_html, named_routes_class)
		puts indent + "forms: "
		print_rails_tag(view_class.get_form_tag_array_from_html, named_routes_class)
		

		# get "ruby helper tags"
		puts indent + "form_for: "
		print_rails_tag(view_class.get_form_for_array, named_routes_class)

		puts indent + "link_to: "
		print_rails_tag(view_class.get_link_to_array, named_routes_class)

		puts "-------------------------"

	end	
end

def load_named_routes(named_routes_path)
	named_routes_class = Named_Routes_Class.new(named_routes_path)
	puts named_routes_class.get_named_routes
end

#load_named_routes "named_routes.txt"

#load_all_controllers("../app/controllers")
load_all_views "./app/views/"


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
