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
    (198/255., 118/255., 255/255.), #dsm added, not Tableau
    (58/255., 208/255., 129/255.),
)

TOTAL_COLOR_NUM=22
colors = [2, 3, 5, 1, 4, 6]
applications = ["boxroom","lobsters","publify","communityengine","jobsworth","onebody","linuxfr","railscollab","rucksack","amahiPlatform"]


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
	plt.xticks(ind,applications)
	#plt.show()
	fig.savefig("%s/general_%s.png"%(result_path, stat_name))

def general_plot(stat_name):
	ary_list = []
	legends = []
	for node in roots[applications[0]]:
		if node.tag == stat_name:
			for c in node:
				ary_list.append([])
				legends.append(c.tag)
	for app in applications:
		for node in roots[app]:
			if node.tag == stat_name:
				i = 0
				for child in node:
					ary_list[i].append(float(child.text))
					i += 1

	for ary in ary_list:
		print "list:"
		print ary
	plot_stack_plot(plt, ary_list, legends, stat_name)

if os.path.isdir(result_path) == False:
	os.system("mkdir %s"%result_path)


for app in applications:
	#print "python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app)
	#os.system("python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app))
	fname = "%s/%s_stat.xml"%(result_path, app)
	tree = ET.parse(fname)
	roots[app] = tree.getroot()

stats = ["queryGeneral","branch","usedInView","onlyFromUser","inClosure","readSink","readSource","writeSource","TableInView","FieldInView","transaction"]

for s in stats:
	print "printing %s..."%s
	general_plot(s)
