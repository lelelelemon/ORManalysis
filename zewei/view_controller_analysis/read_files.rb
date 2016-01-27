require "optparse"

load "data_structure.rb"

def load_all_controllers_from_path(controller_path)
	controller_hash = Hash.new
	Dir.glob(controller_path + "**/*") do |item|
		next if not item.end_with?"_controller.rb"

		controller_hash[item] = Controller_Class.new(item)

	end

	return controller_hash
end

def print_redirect_to_of_all_controllers(controller_path)
	controller_hash = load_all_controllers_from_path(controller_path)

	controller_hash.each do |item_path, controller_class|
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
				puts "#" + tag if $log
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


def load_all_views_from_path(view_path)
	view_hash = Hash.new
	Dir.glob(view_path + "**/*") do |item|
		next if not item.end_with?".erb"

		view_class = View_Class.new(item, view_path)
		view_hash[view_class.get_controller_name + "_"  + view_class.get_view_name] = view_class
	end
	return view_hash
end

def print_all_controllers_render_replaced(controller_path, view_path)
	controller_hash = load_all_controllers_from_path(controller_path)
	view_hash = load_all_views_from_path(view_path)

	view_hash.each do |k, v|
		puts k
		puts v.get_rb_content
	end

	controller_hash.each do |item_path, controller_class|
		controller_class.get_functions.each do |k, v|

			puts "controller: " + controller_class.get_controller_name
			puts "action: " + k

			puts v.replace_render_statements(view_hash)

			puts "----------------------"
		end
	end
end

def load_named_routes_from_path(named_routes_path)
	named_routes_class = Named_Routes_Class.new(named_routes_path)
	return named_routes_class
#	puts named_routes_class.get_named_routes
end

def print_links_in_all_views(view_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	#puts named_routes_class.get_named_routes
	view_hash = load_all_views_from_path(view_path)

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

	#	puts indent + "replace render statements: "
	#	puts view_class.replace_render_statements(view_hash)

		puts "-------------------------------------------"

	end	
end


def load_all_views_render_statement(view_path)
	view_hash = load_all_views_from_path(view_path)

#	view_hash["/home/osboxes/ORM/lobsters/app/views/layouts/application.html.erb"] = View_Class.new("/home/osboxes/ORM/lobsters/app/views/layouts/application.html.erb", view_path)

	indent = "---"

	view_hash.each do |item_path, view_class|
		puts indent + "view_path: " + item_path
#load_named_routes "named_routes.txt"

		puts view_class.replace_render_statements(view_hash)

		puts "-------------------------------------------"
	end
end
#load_all_controllers("../app/controllers")
#load_all_views "./app/views/"

$controller_path = "./app/controllers/"
$view_path = "./app/views/"

options = {}

opt_parser = OptionParser.new do |opt|
	opt.banner = "Usage: ruby read_files.rb [OPTIONS]"
	opt.on("-v", "--view", "load all views and print links in views", "example: --view") do
		options[:view] = true
	end
	opt.on("-r", "--render", "replace render statements", "example: --render") do 
		options[:render] = true
	end
	opt.on("-l", "--log", "log the information of original lines of code", "example: --log") do
		options[:log] = true
	end
end

opt_parser.parse!

if options[:log]
	$log = true
end

if options[:view]
	print_links_in_all_views($view_path)	
end

#load_all_views_render_statement "./app/views/"

#print_all_controllers_render_replaced("./app/controllers/", "./app/views/")

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
