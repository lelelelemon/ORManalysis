#!/usr/bin/python
import glob
import os
import string

base_path = "../applications/lobsters/"
entryfile_path = "../zewei/extract_forms_href/href_from_views/lobsters/"

routes_path = "%s/routes.rb"%base_path
output_path = "%s/results/"%base_path

entries = []

for subdir, folders, files in os.walk(entryfile_path):
	for fn in files:
		fp = open(os.path.join(subdir, fn), "r")
		for line in fp:
			line = line.replace("\n","")
			if line not in entries:
				entries.append(line)

for line in entries:
	chs = line.split(",")
	chs[0] = chs[0].title()
	controller_name = "%sController"%chs[0]
	folder = "%s/%s_%s"%(output_path, controller_name, chs[1])
	if os.path.isdir(folder) == 0:
		os.system("mkdir %s"%folder)
	else:
		os.system("rm %s/*"%folder)
	print "%s # %s"%(controller_name, chs[1])
	os.system("ruby parsing.rb -d %s -t %s,%s -o %s &> %s/trace.temp"%(base_path, controller_name, chs[1], folder, folder))
	os.system("ruby parsing.rb -d %s -s %s,%s -o %s"%(base_path, controller_name, chs[1], folder))
	for filename in glob.iglob("%s/*.log"%folder):
		graph_fname = filename.replace(".log", ".pdf")
		os.system("dot -Tpdf %s -o %s"%(filename, graph_fname))
			 
