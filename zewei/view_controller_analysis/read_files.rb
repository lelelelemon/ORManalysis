require "optparse"
require "unicode"
load "data_structure.rb"

def load_all_controllers_from_path(controller_path)
	controller_hash = Hash.new
	Dir.glob(controller_path + "**/*") do |item|
		next if not item.end_with?"_controller.rb"
#    puts item
		controller = Controller_Class.new(item, controller_path)
		controller_hash[controller.get_controller_name] = controller

	end

  if $lib_controller_path
    puts "start loading controllers from the library"
    Dir.glob($lib_controller_path + "**/*") do |item|
      next if not item.end_with?"_controller.rb"
 #     puts item
      controller = Controller_Class.new(item, $lib_controller_path)
      controller_hash[controller.get_controller_name] = controller
    end
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

def load_all_views_from_path(view_path)
	view_hash = Hash.new
	Dir.glob(view_path + "**/*") do |item|
		next if not item.end_with?(".erb", ".rjs", "jbuilder")
	#  puts item
    view_class = View_Class.new(item, view_path)
		key = view_class.get_controller_name + "_" + view_class.get_view_name
#		key = view_class.get_file_type + "_" + key if view_class.get_file_type != "html"

    view_hash[key] = view_class
	  _key = key.gsub "__", "_"
    if not view_hash.has_key? _key
      view_hash[_key] = view_class
    end
  end

  if $lib_view_path
    Dir.glob($lib_view_path + "**/*") do |item|
      next if not item.end_with?(".erb", ".rjs", "jbuilder")
  #    puts item
      view_class = View_Class.new(item, $lib_view_path)
      key = view_class.get_controller_name + "_" + view_class.get_view_name
      view_hash[key] = view_class
      _key = key.gsub "__", "_"
      if not view_hash.has_key? _key
        view_hash[_key] = view_class
      end
    end

  end

	return view_hash
end

def load_all_helpers_from_path(helper_path)
  helper_hash = {}
  Dir.glob(helper_path + "**/*") do |item|
    next if not item.end_with?(".rb")
    puts item

    helper_class = Helper_Class.new(item)
    helper_hash[item] = helper_class
  end
  return helper_hash
end

def print_view_hash(view_hash)
	view_hash.each do |view_name, view_class|
		puts "view name of view hash: " + view_name
	end
end
		

#print all controller classes with render statements replaced by the correponding view files, all render statements replaced recursively 
def controller_print_all_controllers_render_replaced(controller_path, view_path, new_controller_path)
	controller_hash = load_all_controllers_from_path(controller_path)
	view_hash = load_all_views_from_path(view_path)
	
	print_view_hash view_hash

	controller_hash.each do |item_path, controller_class|
		nested_path = get_nested_path(controller_class.get_controller_name)
		filename = get_filename_from_path(controller_class.get_controller_name)
		if not File.directory?(new_controller_path + nested_path)
			FileUtils.mkdir_p new_controller_path + nested_path
		end
		controller_file_path = new_controller_path + nested_path + filename + "_controller.rb"
		res = controller_class.get_content
		controller_class.get_functions.each do |k, v|
			res = res.gsub(v.get_content){v.replace_render_statements(view_hash, controller_hash)}
		end

		File.write(controller_file_path, res)
	end
end

def count_number_of_lines_rendered_by_view(view_path, controller_path, render_list_path)
  view_hash = load_all_views_from_path(view_path)
  #return a hash of rendered list
  #render_hash[action] = [view1, view2, ...]
  render_hash = load_all_rendered_views(render_list_path)
  render_hash.each do |action, view_list|
    puts "ACTION: " + action
    view_list.each do |view|
      puts "VIEW: " + view
      view_class = view_hash[view]
      puts "number of ruby code: " + view_class.get_lines_rb_content.to_s
      puts "number of ruby and html code: " + view_class.get_lines_content.to_s
    end
  end

end

def helper_print_all_helpers_render_replaced(helper_path, view_path, new_helper_path)
  helper_hash = load_all_helpers_from_path(helper_path)
  view_hash = load_all_views_from_path(view_path)

  helper_hash.each do |item_path, helper_class|
    nested_path = get_nested_path_with_base(item_path, helper_path)
    filename = get_filename_from_path(item_path)
    if not File.directory?(new_helper_path + nested_path)
      FileUtils.mkdir_p new_helper_path + nested_path
    end 
    helper_file_path = new_helper_path + nested_path + filename
    res = helper_class.replace_render_statements(view_hash, 0)
    File.write(helper_file_path, res)
  end
end

def load_named_routes_from_path(named_routes_path)
	named_routes_class = Named_Routes_Class.new(named_routes_path)
	return named_routes_class
#	puts named_routes_class.get_named_routes
end


#TODO need to implement this function
def print_links_in_all_views_render_replaced(view_path, controller_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	#puts named_routes_class.get_named_routes
	view_hash = load_all_views_from_path(view_path)
	controller_hash = load_all_controllers_from_path(controller_path)

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
		print_form_for_tag(view_class.get_form_for_array, named_routes_class, controller_hash)

		puts indent + "link_to: "
		print_rails_tag(view_class.get_link_to_array, named_routes_class)

	#	puts indent + "replace render statements: "
	#	puts view_class.replace_render_statements(view_hash)

		puts "-------------------------------------------"

	end	
end


def print_links_in_all_views(view_path, controller_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	#puts named_routes_class.get_named_routes
	view_hash = load_all_views_from_path(view_path)
	controller_hash = load_all_controllers_from_path(controller_path)

	view_hash.each do |item_path, view_class|
		puts view_class.get_all_links_controller_view(named_routes_class, controller_hash)
		puts "-------------------------------------"
	end

end

def load_all_views_render_statement(view_path)
	view_hash = load_all_views_from_path(view_path)

	indent = "---"

	view_hash.each do |item_path, view_class|
		puts indent + "view_path: " + item_path
#load_named_routes "named_routes.txt"

		puts view_class.replace_render_statements(view_hash)

		puts "-------------------------------------------"
	end
end

def view_replace_render_statements(view_path, controller, view)
	view_hash = load_all_views_from_path(view_path)

	indent = "---"

	view_class = view_hash[controller + "_" + view]

	puts view_class.replace_render_statements(view_hash)
end

def view_print_render_statements_recursively(view_path, controller, view)
	view_hash = load_all_views_from_path(view_path)
	indent = "---"
	view_class = view_hash[controller + "_" + view]
	puts view_class.get_render_statements_recursively(view_hash)
end

def view_print_links_controller_view_recursively(view_path, controller_path, controller, view)
	view_hash = load_all_views_from_path(view_path)
	controller_hash = load_all_controllers_from_path(controller_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	
	indent = "---"
	view_class = view_hash[controller + "_" + view]
	puts view_class.get_links_controller_view_recursively(view_hash, named_routes_class, controller_hash)
end

def controller_action_print_links_controller_view_recursively(view_path, controller_path, controller, action)
	view_hash = load_all_views_from_path(view_path)
	controller_hash = load_all_controllers_from_path(controller_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	
	indent = "---"
	controller_class = controller_hash[controller]
	function_class = controller_class.get_functions[action]
	puts "controller: " + function_class.get_controller_name
	puts "action: " + function_class.get_function_name 
	puts function_class.get_links_controller_view_recursively(view_hash, named_routes_class, controller_hash)
end

def controller_print_links_controller_view_recursively(view_path, controller_path, new_view_path)
	view_hash = load_all_views_from_path(view_path)
	
	view_hash.each do |view_name, view_class|
		puts view_name
	end

	controller_hash = load_all_controllers_from_path(controller_path)
	named_routes_class = load_named_routes_from_path("named_routes.txt")
	
	indent = "---"
	controller_hash.each do |controller_name, controller_class|
		nested_path = get_nested_path(controller_class.get_controller_name)
		filename = get_filename_from_path(controller_class.get_controller_name)	
		puts nested_path
		if not File.directory?(new_view_path + nested_path)
			FileUtils.mkdir_p new_view_path + nested_path
		end
		puts "-------------------Start of Controller Class: " + controller_name + "-------------------"
		controller_class.get_functions.each do |function_name, function_class|
			filepath = new_view_path + nested_path + Unicode::capitalize(filename) + "Controller_" + function_name + ".txt"
			
			puts "-------------------Start of Action Function: " + function_name
			File.write(filepath, function_class.get_links_controller_view_recursively(view_hash, named_routes_class, controller_hash))
			puts "-------------------End of Action Function: " + function_name
		end
		puts "-------------------End of Controller Class: " + controller_name + "-------------------"
	end
	
end

def controller_print_links_controller_view_recursively_by_controller(view_path, controller_path, new_view_path, controller_name)
  view_hash = load_all_views_from_path(view_path)

  view_hash.each do |view_name, view_class|
    puts view_name
  end

  controller_hash = load_all_controllers_from_path(controller_path)
  named_routes_class = load_named_routes_from_path("named_routes.txt")

  indent = "---"
  controller_class = controller_hash[controller_name]
  nested_path = get_nested_path(controller_class.get_controller_name)
  filename = get_filename_from_path(controller_class.get_controller_name)	
  if not File.directory?(new_view_path + nested_path)
    FileUtils.mkdir_p new_view_path + nested_path
  end
  puts "-------------------Start of Controller Class: " + controller_name + "-------------------"
  controller_class.get_functions.each do |function_name, function_class|
    filepath = new_view_path + nested_path + Unicode::capitalize(filename) + "Controller_" + function_name + ".txt"

    puts "-------------------Start of Action Function: " + function_name
    File.write(filepath, function_class.get_links_controller_view_recursively(view_hash, named_routes_class, controller_hash))
    puts "-------------------End of Action Function: " + function_name
  end
  puts "-------------------End of Controller Class: " + controller_name + "-------------------"

end

def controller_replace_render_statements(controller_path, view_path, controller=nil, action=nil)
	controller_hash = load_all_controllers_from_path(controller_path)
	view_hash = load_all_views_from_path(view_path)

	indent = "---"

	if controller != nil
		controller_class = controller_hash[controller]
		
		if action != nil
			puts indent + "action: " + action
			action_class = controller_class.get_functions[action]
			puts action_class.replace_render_statements(view_hash)		
		else
			controller_class.get_functions.each do |action_name, action_class|
				puts indent + "action: " + action_name
				puts action_class.replace_render_statements(view_hash)
				puts "------------------------------------------"
			end
		end
	end

end

def controller_get_render_views_recursively(controller_path, view_path, controller=nil, action=nil)
	controller_hash = load_all_controllers_from_path(controller_path)
	view_hash = load_all_views_from_path(view_path)

	indent = "---"

	if controller != nil
		controller_class = controller_hash[controller]
		
		if action != nil
			puts indent + "action: " + action
			action_class = controller_class.get_functions[action]
			render_stmts = action_class.get_render_views_recursively(view_hash)
			puts render_stmts.length
			render_stmts.each do |stmt|
				puts stmt
			end
		else
			controller_class.get_functions.each do |action_name, action_class|
				puts indent + "action: " + action_name
				action_class.get_render_views_recursively(view_hash).each do |stmt|
					puts stmt
				end
				puts "------------------------------------------"
			end
		end
	end
end

#load_all_controllers("../app/controllers")
#load_all_views "./app/views/"

$controller_path = "./app/controllers/"
$new_controller_path = "./app/new_controllers/"
$helper_path = "./app/helpers/"
$new_helper_path = "./app/new_helpers/"
$view_path = "./app/views/"
$new_view_path = "./app/new_views/"
$output_path = "./output/"
$lib_controller_path = "../calagator/app/controllers/"
$lib_view_path = "../calagator/app/views/"
$render_list_path = "./render_list.txt"

options = {}

opt_parser = OptionParser.new do |opt|
	opt.banner = "Usage: ruby read_files.rb [OPTIONS]"
	opt.on("-v", "--view", "load all views and print links in views", "example: --view") do
		options[:view] = true
	end
	opt.on("-r", "--render controller,view", Array, "replace render statements in view file under a certain controller directory", "example: --render stories/index") do |item|
		options[:render] = true
		options[:target] = item
	end
	opt.on("-c", "--controller", "get information for controller classes") do
		options[:controller] = true
	end
	opt.on("-l", "--log", "log the information of original lines of code", "example: --log") do
		options[:log] = true
	end
	opt.on("-s", "--statements", "get render statements only") do 
		options[:statements] = true
	end
	opt.on("-a", "--all", "apply the current operation on all controller actions or view files") do 
		options[:all] = true
	end
  opt.on("-loc", "--linesofcode", "count number of lines of code rendered from the views", "example: --linesofcode") do 
    options[:loc] = true
  end
  opt.on("-h", "--helper", "work on helper ruby files") do
    options[:helper] = true
  end
end

opt_parser.parse!

if options[:log]
	$log = true
end

if options[:view] and options[:render] and options[:statements]
	controller = options[:target][0]
	if options[:target].length > 1
		view = options[:target][1]
	else
		view = nil
	end
	
	puts "view: " + controller+ "_" + view
	puts "-----------------------------------------------------------"

	view_print_render_statements_recursively($view_path, controller, view)
	view_print_links_controller_view_recursively($view_path, $controller_path, controller, view)
elsif options[:controller] and options[:render] and options[:statements]
	controller = options[:target][0]
	if options[:target].length > 1
		view = options[:target][1]
	else
		view = nil
	end
	
	puts "controller: " + controller
	puts "-----------------------------------------------------------"

	controller_action_print_links_controller_view_recursively($view_path, $controller_path, controller, view)
#	view_print_render_statments_recursively($controller_path, $view_path, controller, view)
	#controller_get_render_views_recursively($controller_path, $view_path, controller, view)

elsif options[:controller] and options[:render]
	controller = options[:target][0]
	if options[:target].length > 1
		view = options[:target][1]
	else
		view = nil
	end
  controller_print_links_controller_view_recursively_by_controller($view_path, $controller_path, $new_view_path, controller)

elsif options[:render]
	controller = options[:target][0]
	view = options[:target][1]
	#puts "controller: " + controller + ", view: " + view
	view_replace_render_statements($view_path, controller, view)
elsif options[:view]
	print_links_in_all_views($view_path, $controller_path)	
elsif options[:controller] and options[:all]
	controller_print_all_controllers_render_replaced($controller_path, $view_path, $new_controller_path)
elsif options[:controller]
	controller_print_links_controller_view_recursively($view_path, $controller_path, $new_view_path)
elsif options[:loc]
  count_number_of_lines_rendered_by_view($view_path, $controller_path, $render_list_path)
elsif options[:helper]
  helper_print_all_helpers_render_replaced($helper_path, $view_path, $new_helper_path)
end


