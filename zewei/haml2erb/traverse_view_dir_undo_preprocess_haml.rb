require "fileutils"

$view_path = ARGV[0]

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

Dir.glob($view_path + "**/*") do |item|
	nested_path = get_nested_path(item, $view_path)

	file_name = get_file_name_from_path(item)

	if not item.end_with?(".haml.bk")
		next
	end

  system("cp #{item} #{item[0..-4]}")

end
