import os
for root, dirs, files in os.walk("./"):
	for filename in files:
		if filename.endswith(".rb") and "schema.rb" not in filename:
			fname = os.path.join(root, filename)
			f = open(fname, 'r')
			filedata = f.read()
			if filedata.startswith("module Cms"):
				newdata = filedata.replace("module Cms","")
				newdata = newdata[:newdata.rfind('end')]
			
			newdata = newdata.replace("Cms::","")
			f = open(fname, "w+")
			f.write(newdata)
			f.close()

