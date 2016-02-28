import os
for root, dirs, files in os.walk("./"):
	for filename in files:
		if filename.endswith(".rb") and "schema.rb" not in filename:
			fname = os.path.join(root, filename)
			f = open(fname, 'r')
			filedata = f.read()
			newdata = filedata
			if filedata.startswith("module Cms"):
				line = filedata.split("\n")
				#if "extend" in line[-1] and "end" in line[-2]:
					#newdata = "\n".join(line[:-2])
					#newdata = newdata.replace("module Cms","")
				if line[-1].endswith("end"):
					if "module Cms" in line[0]:
						newdata = "\n".join(line[1:-1])
				elif line[-2].endswith("end"):
					if "module Cms" in line[0]:
						newdata = "\n".join(line[1:-2])

			
			newdata = newdata.replace("Cms::","")
			f = open(fname, "w+")
			f.write(newdata)
			f.close()

