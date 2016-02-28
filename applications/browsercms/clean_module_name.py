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
				if newdata.endswith("end") or newdata.endswith("end\n")
					newdata = newdata.replace("module Cms","")
					newdata = newdata[:newdata.rfind('end')]
				else:
					newdata = "\n".join(line[:-2])
					newdata = newdata.replace("module Cms","")

			
			newdata = newdata.replace("Cms::","")
			f = open(fname, "w+")
			f.write(newdata)
			f.close()

