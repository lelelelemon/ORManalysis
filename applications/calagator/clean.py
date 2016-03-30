import os
for root, dirs, files in os.walk("./"):
	for filename in files:
		if filename.endswith(".rb") and "schema.rb" not in filename:
			fname = os.path.join(root, filename)
			f = open(fname, 'r')
			filedata = f.read()
			newdata = filedata
			newdata = newdata.replace("Calagator::","")
			f = open(fname, "w+")
			f.write(newdata)
			f.close()
