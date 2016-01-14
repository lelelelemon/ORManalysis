require "fileutils"

$helper_filename = ARGV[0]
$view_folder = ARGV[1]
$named_routes_view_folder = ARGV[2]

def get_file_name_from_path(filename)
	i = filename.rindex('/')
	if i == nil
		return nil
	end

	n = filename[i+1..filename.length]
	return n
end

def get_nested_path(filepath, basepath)
	i = filepath.rindex(basepath)
	j = filepath.rindex('/')
	if i == nil or j == nil
		return nil
	end
	n = filepath[i+basepath.length..j]
	return n
end

$helper_action_mapping = Hash.new

helper_file = File.new $helper_filename, "r"
while ((line = helper_file.gets) != nil)
	line.strip!
	
	helper = line
	line = helper_file.gets

	line = line[1, line.rindex('}')-1]
	line.gsub! "\"", ""
	items = line.split(',')

	hash = Hash.new
	items.each do |item|
		item.strip!
		a = item.split("=>")
	
		hash[a[0]] = a[1]
	end
	$helper_action_mapping[helper + "_path"] = [hash[":controller"], hash[":action"]]
	$helper_action_mapping[helper + "_url"] = [hash[":controller"], hash[":action"]]

end
helper_file.close

puts $helper_action_mapping

Dir.glob($view_folder + "**/*") do |file|
	nested_path = get_nested_path(file, $view_folder)
	filename = get_file_name_from_path(file)
	if not file.end_with?".erb"
		next
	end
	if not File.directory?($named_routes_view_folder + nested_path)
		FileUtils.mkdir_p $named_routes_view_folder + nested_path
	end
	File.open(file, "r").each_line do |line|
		if not line.
			next
		end

	
		File.open($named_routes_view_folder + nested_path + filename, "a") do |f|
			$helper_action_mapping.each do |key, value|
#				puts key
				if line.include?(key)
 					f.write($helper_action_mapping[key][0] + "," +  $helper_action_mapping[key][1] + "\n")
				end
			end
		end
	end
end
