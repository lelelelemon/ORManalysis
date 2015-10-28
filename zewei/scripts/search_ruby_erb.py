import fnmatch, os, sys

if len(sys.argv) != 3:
	print "Usage: search_ruby_erb.py src_dir output"
	exit()

src_dir = sys.argv[1]
output = sys.argv[2]

fout = open(output, "wb")
for root, dirnames, filenames in os.walk(src_dir):
	#print root, dirnames, filenames
	for filename in filenames:
		if filename.endswith(".erb"):
			filename = os.path.join(root, filename)

			with open(filename, "rb") as fp:
				line_num = 0
				for line in fp:
					line_num += 1
                                
                                        if "<%" in line:
                                                
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

                                                fout.write(filename + " line " + str(line_num) + ": " + line + "\n")


fout.close()
