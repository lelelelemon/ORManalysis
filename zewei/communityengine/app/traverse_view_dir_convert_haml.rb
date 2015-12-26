require "fileutils"

#ruby traverse_view_dir_extract_ruby.rb extract_ruby.exe views

herbalizer_path = "/home/student/.cabal/bin/herbalizer"

base_dir = Dir.pwd
traverse_dir = ARGV[0]
start = File.join(base_dir, traverse_dir)

def walk(start, base_dir, script)
	Dir.foreach(start) do |x|

		next if x == "." or x == ".."
		path = File.join(start, x)
		puts path
		if File.directory?(path)
			walk(path, base_dir, script)
		else
			if x.end_with?".haml"
				new_x = x + ".erb"
				system(script + " " + File.join(start, x) + " > " + File.join(start, new_x))
			end
		end
	end
end

walk(start, base_dir, herbalizer_path)

# puts script
# puts curr_dir
