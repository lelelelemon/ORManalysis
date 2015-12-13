import os
import string

#A python script to go over all the .html.erb files under a directory and extract ruby. Output files into a new dir
#old file: lobsters/views/messages/index.html.erb
#new file: lobsters/view_rb/messages/index/html.erb

rootdir = "../../applications/boxroom/views/"

for subdir, dirs, files in os.walk(rootdir):
    for file in files:
			input_fname = os.path.join(subdir, file)
			output_fname = string.replace(input_fname, 'views', 'view_rb')
			output_directory = string.replace(subdir, 'views', 'view_rb')
			if not os.path.exists(output_directory):
				print "\tMAKING dir: %s"%(output_directory)
				os.makedirs(output_directory)
			print "./extract_ruby %s %s"%(input_fname, output_fname)
			os.system("./extract_ruby %s %s"%(input_fname, output_fname))
