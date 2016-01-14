require "fileutils"

$href_path = ARGV[0]
$new_href_path = ARGV[1]

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

Dir.glob($href_path + "**/*") do |file|
	nested_path = get_nested_path(file, $href_path)
	filename = get_file_name_from_path(file)
	if not file.end_with?(".erb")
		next
	end
	if not File.directory?($new_href_path + nested_path)
		FileUtils.mkdir_p $new_href_path + nested_path
	end
	File.open(file, "r").each_line do |line|
		if not line.start_with?("{") 
			next
		end

	
		line = line[1, line.rindex('}')-1]
		line.gsub! "\"", ""
		items = line.split(',')
	
		hash = Hash.new
		items.each do |item|
			item.strip!
			a = item.split("=>")
		
			hash[a[0]] = a[1]
		end
		File.open($new_href_path + nested_path + filename, "a") do |f|
 			f.write(hash[":controller"] + "," +  hash[":action"] + "\n")
		end
	end
end
