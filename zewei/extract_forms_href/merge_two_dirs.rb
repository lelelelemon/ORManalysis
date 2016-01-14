require "fileutils"

$folder1 = ARGV[0]
$folder2 = ARGV[1]
$folder3 = ARGV[2]

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

def traverse_ast(ast, f)
	if ast != nil and ast.source.start_with?"form_for"
		f.write ast.source
	else
		ast.children.each do |child|
			traverse_ast child, f
		end
	end
end

Dir.glob($folder1 + "**/*") do |file|
	nested_path = get_nested_path(file, $folder1)
	filename = get_file_name_from_path(file)
	if not file.end_with?".erb"
		next
	end
	if not File.directory?($folder3 + nested_path)
		FileUtils.mkdir_p $folder3 + nested_path
	end
	
	content1 = File.open(file, "r").read
		puts $folder2 + nested_path + filename
	if File.exist?($folder2 + nested_path + filename)
		content2 = File.open($folder2 + nested_path + filename, "r").read
		File.write($folder3 + nested_path + filename, content1 + content2)
	else
		File.write($folder3 + nested_path + filename, content1)
	end
	
end

Dir.glob($folder2 + "**/*") do |file|
	nested_path = get_nested_path(file, $folder2)
	filename = get_file_name_from_path(file)
	if not file.end_with?".erb"
		next
	end
	if not File.directory?($folder3 + nested_path)
		FileUtils.mkdir_p $folder3 + nested_path
	end
	
	content2 = File.open(file, "r").read
		puts $folder1 + nested_path + filename
	if File.exist?($folder1 + nested_path + filename)
		content1 = File.open($folder1 + nested_path + filename, "r").read
		File.write($folder3 + nested_path + filename, content1 + content2)
	else
		File.write($folder3 + nested_path + filename, content2)
	end
	
end
