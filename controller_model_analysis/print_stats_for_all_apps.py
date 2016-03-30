import numpy as np
import xml.etree.ElementTree as ET
import sys
import glob
import os
import matplotlib.pyplot as plt
tableau_colors = (
    (114/255., 158/255., 206/255.),
    (255/255., 158/255.,  74/255.),
    (103/255., 191/255.,  92/255.),
    (237/255., 102/255.,  93/255.),
    (173/255., 139/255., 201/255.),
    (168/255., 120/255., 110/255.),
    (237/255., 151/255., 202/255.),
    (162/255., 162/255., 162/255.),
    (205/255., 204/255.,  93/255.),
    (109/255., 204/255., 218/255.),
    (144/255., 169/255., 202/255.),
    (225/255., 157/255.,  90/255.),
    (122/255., 193/255., 108/255.),
    (225/255., 122/255., 120/255.),
    (197/255., 176/255., 213/255.),
    (196/255., 156/255., 148/255.),
    (247/255., 182/255., 210/255.),
    (199/255., 199/255., 199/255.),
    (219/255., 219/255., 141/255.),
    (158/255., 218/255., 229/255.),
    (227/255., 119/255., 194/255.),
		(219/255., 219/255., 141/255.),
		(174/255., 199/255., 232/255.),
		(109/255., 204/255., 218/255.),
		(114/255., 158/255., 206/255.),
		(199/255., 199/255., 199/255.),
		(188/255., 189/255., 34/255.),
		(255/255., 127/255., 14/255.),
		(255/255., 125/255., 150/255.),
		(196/255., 156/255., 148/255.),
		(177/255., 3/255., 24/255.),
		(0/255., 107/255., 164/255),
    (198/255., 118/255., 255/255.), #dsm added, not Tableau
    (58/255., 208/255., 129/255.),
)

TOTAL_COLOR_NUM=33
colors = [2, 3, 5, 1, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 0]
#applications = ["boxroom","fulcrum","kandan","linuxfr","publify", "lobsters", "railscollab","communityengine","onebody","sugar","railscollab","browsercms","brevidy","amahiPlatform","amahiPlatform_layouts","rucksack","rucksack_layouts"]
#app_string="lobsters amahiPlatform fulcrum linuxfr onebody rucksack sugar boxroom jobsworth kandan publify railscollab rucksack sharetribe tracks brevidy communityengine"

#app_string="amahiPlatform railscollab jobsworth communityengine sharetribe linuxfr rucksack fulcrum tracks brevidy lobsters onebody sugar publify boxroom"
app_string="lobsters amahiPlatform fulcrum linuxfr onebody rucksack sharetribe sugar boxroom publify railscollab tracks brevidy communityengine forem enki calagator"
#app_string="sugar lobsters boxroom enki publify amahiPlatform railscollab linuxfr calagator forem fulcrum tracks brevidy"

#app_string="calagator forem fulcrum tracks brevidy"

applications = app_string.split(" ")

result_path = "../applications/general_stats/"
width = 0.2

roots = {}
def plot_stack_plot(plt, ary_list, legends, stat_name):
	fig = plt.figure()
	ax = fig.add_subplot(111)

	N = len(applications)
	ind = np.arange(N)
	bottom_data = []
	rects = []
	for i in range(N):
		bottom_data.append(0)
	j = 0
	for ary in ary_list:
		#data of all apps in a single category
		rects.append(ax.bar(ind, ary, width, bottom=bottom_data, color=tableau_colors[colors[j]]))
		j += 1
		for i in range(N):
			bottom_data[i] += ary[i]
	ax.legend(rects, legends, loc='upper right', prop={'size':'10'})
	plt.xticks(ind,applications,rotation='vertical')
	plt.tick_params(labelsize=8)
	#plt.show()
	fig.savefig("%s/general_%s.pdf"%(result_path, stat_name))

def general_plot(stat_name):
	ary_list = []
	legends = []
	name_map = {}
	for app in applications:
		for node in roots[app]:
			if node.tag == stat_name:
				for c in node:
					if c.tag not in legends:
						name_map[c.tag] = len(ary_list)
						ary_list.append([])
						legends.append(c.tag)
	for app in applications:
		for node in roots[app]:
			if node.tag == stat_name:
				included = []
				for child in node:
					included.append(child.tag)
					ary_list[name_map[child.tag]].append(float(child.text))
				for l in legends:
					if l not in included:
						ary_list[name_map[l]].append(0)
					#ary_list[i].append(float(child.text))
				#if len(legends) > i:
				#	for j in range(len(legends)-i):
				#		ary_list[i].append(0)
				#		i += 1

	for ary in ary_list:
		print "list:"
		print ary
	if stat_name == "queryGeneral":
		temp_ary = {}
		for app in applications:
			temp_ary[app] = 0
		i = 0
		for app in applications:
			for ary in ary_list:
				temp_ary[app] += ary[i]
			i = i + 1
		print "TOTAL QUERY:"
		for app in applications:
			temp_ary[app] = temp_ary[app] * len(roots[app])
			print "%s: %d"%(app, temp_ary[app])	
	plot_stack_plot(plt, ary_list, legends, stat_name)

if os.path.isdir(result_path) == False:
	os.system("mkdir %s"%result_path)


for app in applications:
	print "python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app)
	os.system("python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app))	
	#print "python collect_nextaction.py %s "%(app)
	#os.system("python collect_nextaction.py %s %s/nextaction_%s_stat.xml"%(app, result_path, app))
	#print "python collect_funcdeps.py %s %s/%s_funcdeps.log"%(app, result_path, app)
	#os.system("python collect_funcdeps.py %s %s/%s_funcdeps.log"%(app, result_path, app))
	fname = "%s/%s_stat.xml"%(result_path, app)
	print fname
	tree = ET.parse(fname)
	roots[app] = tree.getroot()
	print ""

#stats=[]
stats = ["queryGeneral","branch","branchInView","usedInView","usedSQLString","onlyFromUser","queryTrivialBranch","inClosure","readSink","readSource","writeSource","TableInView","FieldInView","transaction","transactionNested", "queryString", "constStat"]
#stats = ["usedSQLString"]

for s in stats:
	print "printing %s..."%s
	general_plot(s)

exit(0)
#NA stands for NextAction
roots = {}
app_string="lobsters amahiPlatform fulcrum onebody rucksack sharetribe jobsworth publify railscollab tracks brevidy communityengine"

applications = app_string.split(" ")

for app in applications:
	fname = "%s/nextaction_%s_stat.xml"%(result_path, app)
	tree = ET.parse(fname)
	roots[app] = tree.getroot()

#general_plot("nextAction")


