require "rubygems"
require "nokogiri"
require "fileutils"

$view_path = ARGV[0]
$new_view_path = ARGV[1]

def select_href(oldfile, newfile)
	page = Nokogiri::HTML(open(oldfile))

	File.open(newfile, "w") do |f|
		f.write "route = Rails.application.routes\n"
		page.css("a").each do |a|
			href = a["href"]
			href = "" if href == nil
			href.gsub! /<%.*%>/, "2"
			f.write "route.recognize_path " + href + "\n"
		end
	end
end



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

	if not item.end_with?(".html.erb")
		next
	end
	
	if not File.directory?($new_view_path + nested_path)
		puts $new_view_path + nested_path
		FileUtils.mkdir_p $new_view_path + nested_path
	end

	select_href item, $new_view_path + nested_path + file_name	
end
