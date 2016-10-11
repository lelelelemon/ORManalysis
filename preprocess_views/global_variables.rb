$app_name = ""
$path_prefix = ""
$view_folder_name = "views"
$new_view_folder_name = "ruby_views"
$extract_ruby_script = "./extract_ruby"
$view_dir = ""
$view_files = Hash.new

$controller_dir = ""
$new_controller_dir = ""
$helper_dir = ""
$new_helper_dir = ""
$controller_folder_name = "controllers"
$new_controller_folder_name = "merged_controllers"
$helper_folder_name = "helpers"
$new_helper_folder_name = "merged_helpers"
$actions = Hash.new
$controllers = Hash.new
$helpers = Hash.new
$cur_class = nil
$cur_action = nil
$has_helper = false

$node_stack = nil
