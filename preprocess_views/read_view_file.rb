def read_view_files
	root, files, dirs = os_walk($view_dir)
	for filename in files
		if filename.to_s.end_with?("html.erb")
			new_file_name = filename.to_s.gsub($view_folder_name, $new_view_folder_name)
			#TODO: full path
			view_file = View_file.new(new_file_name)
			$view_files[new_file_name] = view_file
			
			run_command("#{$extract_ruby_script} #{filename} #{new_file_name}")
		end
	end
end
