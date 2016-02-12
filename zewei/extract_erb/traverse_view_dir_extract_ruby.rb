require "fileutils"

#ruby traverse_view_dir_extract_ruby.rb extract_ruby.exe views

script = ARGV[0]
base_dir = Dir.pwd
traverse_dir = ARGV[1]
start = File.join(base_dir, traverse_dir)

def walk(start, base_dir, script)
	Dir.foreach(start) do |x|

		next if x == "." or x == ".."
		path = File.join(start, x)
		puts path
		if File.directory?(path)
			walk(path, base_dir, script)
		else
			FileUtils.cp(File.join(base_dir, script), File.join(start, script))
			if x.end_with?".erb"
				new_x = x + ".rb"
				system(File.join(start, script) + " " + File.join(start, x) + " " + File.join(start, new_x))
			end
		end
	end
end

walk(start, base_dir, script)

# puts script
# puts curr_dir
