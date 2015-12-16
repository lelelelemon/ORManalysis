#!/usr/bin/python
import glob
import os
import string

base_path = "../applications/lobsters/"

routes_path = "%s/routes.rb"%base_path
output_path = "%s/results/"%base_path

r_fp = open(routes_path, "r")
routes_map = []
for line in r_fp:
	splt = line.split(" ")
	for w in splt:
		if w.find('#') != -1:
			chs = w.replace("\"","").replace("\'","").replace("\n","").replace(",","").split('#')
			map_key = "%s#%s"%(chs[0], chs[1])
			if map_key not in routes_map:
				list1 = list(chs[0])
				list1[0] = list1[0].upper()
				chs[0] = ''.join(list1)
				chs[0] = "%sController"%chs[0]
				print "%s # %s"%(chs[0], chs[1])
				routes_map.append(map_key)
				
				folder = "%s/%s_%s"%(output_path, chs[0], chs[1])
				if os.path.isdir(folder) == 0:
					os.system("mkdir %s"%folder)
				else:
					os.system("rm %s/*"%folder)
				os.system("ruby parsing.rb -d %s -t %s,%s -o %s &> %s/trace.temp"%(base_path, chs[0], chs[1], folder, folder))
				os.system("ruby parsing.rb -d %s -s %s,%s -o %s"%(base_path, chs[0], chs[1], folder))
				for filename in glob.iglob("%s/*.log"%folder):
					graph_fname = filename.replace(".log", ".pdf")
					os.system("dot -Tpdf %s -o %s"%(filename, graph_fname))
			 
