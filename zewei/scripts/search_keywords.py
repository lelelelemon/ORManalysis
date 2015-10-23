#!/usr/bin/python
import fnmatch, os, sys

if len(sys.argv) != 4:
	print "Usage: search_keywords.py keywords_file src_dir output_file"
	exit()

keywords_file = sys.argv[1]
src_dir = sys.argv[2]
output_file = sys.argv[3]

keywords = {}
with open(keywords_file, "rb") as fp:
	for line in fp:
		#windows \r\n
		if line[len(line)-1:] == '\n':
			line = line[:len(line)-1] 
		if line[len(line)-1:] == '\r':
			line = line[:len(line)-1]
		keywords[line] = 0

print keywords

fout = open(output_file, "wb")

for root, dirnames, filenames in os.walk(src_dir):
	#print root, dirnames, filenames
	for filename in filenames:
		if filename.endswith(".rb"):
			filename = os.path.join(root, filename)
		
			with open(filename, "rb") as fp:
				line_num = 0
				for line in fp:
					line_num += 1
					for keyword in keywords:
						if keyword in line:
							
							keywords[keyword] += 1	
							#delete all spaces in the front
							space_num = 0
							while line[space_num] == ' ':
								space_num += 1
							line = line[space_num:]

							#delete comments
							if line[0] == '#':
								continue


							if line[len(line)-1:] == "\n":
								line = line[:len(line)-1]

							fout.write("keyword: " + keyword + "\n")
							fout.write(filename + " line " + str(line_num) + ": " + line + "\n")

for keyword in keywords:
	fout.write(keyword + ": " + str(keywords[keyword]) + "\n")

fout.close()
