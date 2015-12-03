
require "FileUtils"


controller_folder = ARGV[0]
puts controller_folder
output_folder = ARGV[1]
puts output_folder
script = "merge_controller_and_view.rb"
base = Dir.pwd

#ruby traverse_view_dir_extract_ruby.rb extract_ruby.exe views

def walk(base, input_folder, output_folder, script)
	Dir.foreach(input_folder) do |x|

		next if x == "." or x == ".."

		if File.directory?(x)
			input_folder = File.join(input_folder, x)
			output_folder = File.join(output_folder, x)
			walk(base, input_folder, output_folder, script)
		else
			if x.end_with?"_controller.rb"
				puts File.join(input_folder, x)
				puts File.join(output_folder, x)
				system("ruby " + File.join(base, script) + " " + 
					input_folder + " " + x[0..-15] + " > " + File.join(output_folder, x))
			end
		end
	end
end

walk(base, controller_folder, output_folder, script)