require 'optparse'

load 'global_variables.rb'
load 'helper.rb'
load 'util.rb'
load 'get_render.rb'
load 'read_view_file.rb'
load 'read_controller_file.rb'
load 'recursive_render.rb'

options = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: ruby main.rb [OPTIONS]"

	opt.on("-a","--application APP",String,"Application name","example: -a redmine") do |app|
		options[:application] = app
		$app_name = app
	end
	
	opt.on("-m","--haml","Is Haml code","example: -m") do |haml|
		options[:haml] = true
	end

	opt.on("-e", "--has-helper","Has helper folder","example: -e") do |helper|
		options[:helper] = true
		$has_helper = true
	end

	opt.on("-h","--help","help") do
		options[:help] = true
    puts opt_parser
		puts "=================="
		puts "Example: ruby main.rb -a boxroom"
  end

end

opt_parser.parse!

if options[:help]
	exit
end

if options[:haml]
else
	$path_prefix = "../applications/#{options[:application]}/"
	$view_dir = "../applications/#{options[:application]}/#{$view_folder_name}/"
	$new_view_dir = "../applications/#{options[:application]}/#{$new_view_folder_name}/"
	run_command("rm -rf #{$new_view_dir}")
	run_command("mkdir #{$new_view_dir}")
	$controller_dir = "../applications/#{options[:application]}/#{$controller_folder_name}/"
	$new_controller_dir = "../applications/#{options[:application]}/#{$new_controller_folder_name}/"
	run_command("rm -rf #{$new_controller_dir}")
	run_command("mkdir #{$new_controller_dir}")
	if options[:helper]
		$helper_dir = "../applications/#{options[:application]}/#{$helper_folder_name}/"
		$new_helper_dir = "../applications/#{options[:application]}/#{$new_helper_folder_name}/"
		run_command("rm -rf #{$new_helper_dir}")
		run_command("mkdir #{$new_helper_dir}")
	end
end

read_view_files
read_controller_files($controller_dir, true)
if options[:helper]
	read_controller_files($helper_dir, false)
end
#The following function should be called twice because I am not recursively solving upper class...
resolve_upper_class
resolve_upper_class
read_entrance_actions
solve_all_renders
replace_files
