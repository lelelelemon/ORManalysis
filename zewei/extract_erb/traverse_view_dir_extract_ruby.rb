require "fileutils"
require 'pathname'

#ruby traverse_view_dir_extract_ruby.rb extract_ruby.exe views

script = ARGV[0]
base_dir = Dir.pwd
traverse_dir = ARGV[1]
start = File.join(base_dir, traverse_dir)

def os_walk(dir)
  root = Pathname(dir)
  files, dirs = [], []
  Pathname(root).find do |path|
    unless path == root
      dirs << path if path.directory?
      files << path if path.file?
    end
  end
  [root, files, dirs]
end

root, files, dirs = os_walk(start)
for filename in files
	if filename.to_s.end_with?(".erb")
		new_file = filename.to_s+".rb"
		system(File.join(base_dir, script) + " #{filename.to_s} #{new_file}")
	end
end

def walk(start, base_dir, script)
	Dir.foreach(start) do |x|

		next if x == "." or x == ".."
		path = File.join(start, x)
		puts path
		if File.directory?(path)
			walk(path, base_dir, script)
		else
			if x.end_with?".erb"
				new_x = x + ".rb"
				system(File.join(base_dir, script) + " " + File.join(start, x) + " " + File.join(start, new_x))
			end
		end
	end
end

#walk(start, base_dir, script)

# puts script
# puts curr_dir
