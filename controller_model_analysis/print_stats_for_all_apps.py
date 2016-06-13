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
colors = [2, 3, 5, 1, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
#app_string="lobsters amahiPlatform fulcrum linuxfr onebody rucksack sugar boxroom jobsworth kandan publify railscollab rucksack sharetribe tracks brevidy communityengine"

app_string = "enki calagator boxroom publify shoppe sugar brevidy linuxfr wallgig lobsters tracks diaspora railscollab rucksack communityengine amahiPlatform kandan fulcrum forem kanban"
#app_string="lobsters amahiPlatform fulcrum linuxfr rucksack sugar boxroom publify brevidy railscollab sharetribe communityengine kandan forem enki wallgig calagator shoppe"


applications = app_string.split(" ")
result_path = "../applications/general_stats/"
width = 0.2

roots = {}

def plot_alignedbar_plot(plt, ary_list, legends, stat_name, Ylabel, stack_array):
	fig = plt.figure(figsize=(6,4))
	ax = fig.add_subplot(111)
	N = len(applications)
	ind = np.arange(N)

	rects = []
	j=0
	data_acc = {}
	for i in stack_array:
		data_acc[i] = []
		for j in ary_list[0]:
			data_acc[i].append(0)
	j = 0
	for ary in ary_list:
		rects.append(ax.bar(ind+width*stack_array[j], ary, width, bottom=data_acc[stack_array[j]], color=tableau_colors[colors[j]]))
		k = 0
		for d in ary:
			data_acc[stack_array[j]][k] += d
			k += 1
		j+=1
	ax.legend(rects, legends, loc='upper right', prop={'size':'10'})
	plt.ylabel(Ylabel, fontsize=10)
	plt.xticks(ind,applications,rotation='vertical')
	plt.tick_params(labelsize=10)
	plt.tight_layout()
	#plt.show()
	fig.savefig("%s/general_%s.pdf"%(result_path, stat_name))

def plot_stack_plot(plt, ary_list, legends, stat_name, Ylabel):
	#print stat_name
	#i=0
	#for ary in ary_list:
	#	print legends[i]
	#	print ary
	#	i += 1
	fig = plt.figure(figsize=(6,4))
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
	if len(legends) > 15:
		ax.legend(rects, legends, loc='upper right', prop={'size':'4'})
	else:
		ax.legend(rects, legends, loc='upper right', prop={'size':'10'})
	plt.ylabel(Ylabel, fontsize=10)
	plt.xticks(ind,applications,rotation='vertical')
	plt.tick_params(labelsize=10)
	plt.tight_layout()
	#plt.show()
	fig.savefig("%s/general_%s.pdf"%(result_path, stat_name))

def general_plot(stat_name, Ylabel, alignedBar=False, alignedArray={}):
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
	if alignedBar:
		stack_array = []
		k = 0
		for l in legends:
			if l in alignedArray:
				stack_array.append(alignedArray[l])
			else:
				stack_array.append(k)
			k += 1
		plot_alignedbar_plot(plt, ary_list, legends, stat_name, Ylabel, stack_array)
	else:
		plot_stack_plot(plt, ary_list, legends, stat_name, Ylabel)

def plot_field_stat(stat_name):
	x_data = []
	y_data = []
	max_x = 0
	max_y = 0
	i = 0
	for app in applications:
		for node in roots[app]:
			if node.tag == stat_name:
				for c in node:
					if c.text != "MAX" and float(c.text) > max_y:
						max_y = float(c.text)
					if float(c.attrib["numUse"]) > max_x:
						max_x = float(c.attrib["numUse"])

	for app in applications:
		x_data.append([])
		y_data.append([])
		for node in roots[app]:
			if node.tag == stat_name:
				for c in node:
					x_data[i].append(float(c.attrib["numUse"]))
					if c.text == "MAX":
						y_data[i].append(max_y*1.5)
					else:
						y_data[i].append(float(c.text))
		i += 1
	fig = plt.figure(figsize=(6,4))
	ax = fig.add_subplot(111)
	i = 0
	legend_scat = []
	for app in applications:
		l = ax.scatter(x_data[i], y_data[i], color=tableau_colors[i%TOTAL_COLOR_NUM], label=app)
		legend_scat.append(l)	
		i += 1
	ax.legend(legend_scat, applications, bbox_to_anchor=(1.05, 1.05), prop={'size':'10'})
	ax.set_ylim(0, max_y*1.6)
	ax.set_xlim(0, max_x*1.1)
	plt.ylabel("avg path distance to source", fontsize=10)
	plt.xlabel("avg number of use per controller action", fontsize=10)
	plt.tight_layout()
	fig.savefig("%s/general_%s.pdf"%(result_path, stat_name))

def plot_table_stat(stat_name):
	x_data = []
	y_data = []
	i = 0
	x_max = 0
	y_max = 0
	for app in applications:
		x_data.append([])
		y_data.append([])
		for node in roots[app]:
			if node.tag == stat_name:
				for c in node:
					x_data[i].append(float(c.text))
					if float(c.text) > x_max:
						x_max = float(c.text)
					y_data[i].append(float(c.attrib["write"]))
					if float(c.attrib["write"]) > y_max:
						y_max = float(c.attrib["write"])
		i += 1

	fig = plt.figure(figsize=(6,4))
	ax = fig.add_subplot(111)
	i = 0
	legend_scat = []
	for app in applications:
		l = ax.scatter(x_data[i], y_data[i], color=tableau_colors[i%TOTAL_COLOR_NUM], label=app)
		legend_scat.append(l)	
		i += 1
	ax.legend(legend_scat, applications, bbox_to_anchor=(1.05, 1.05), prop={'size':'10'})
	plt.ylabel("avg #write queries on a table", fontsize=10)
	plt.xlabel("avg #read queries on a table", fontsize=10)
	ax.set_ylim(0, y_max*1.1)
	ax.set_xlim(0, x_max*1.6)
	plt.tight_layout()
	fig.savefig("%s/general_%s.pdf"%(result_path, stat_name))


if os.path.isdir(result_path) == False:
	os.system("mkdir %s"%result_path)


for app in applications:
	print "python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app)
	os.system("python collect_stats.py %s %s/%s_stat.xml"%(app, result_path, app))	
	print "python collect_nextaction.py %s "%(app)
	os.system("python collect_nextaction.py %s %s/nextaction_%s_stat.xml"%(app, result_path, app))
	#print "python collect_funcdeps.py %s %s/%s_funcdeps.log"%(app, result_path, app)
	#os.system("python collect_funcdeps.py %s %s/%s_funcdeps.log"%(app, result_path, app))
	fname = "%s/%s_stat.xml"%(result_path, app)
	print fname
	tree = ET.parse(fname)
	roots[app] = tree.getroot()
	print ""

#stats=["tableFieldCompute"]
stats = ["queryGeneral","branch","branchInView","queryInView","usedInView","usedSQLString","onlyFromUser","inClosure","readSink","readSource","writeSource","TableInView","assocQuery","transaction","transactionNested", "queryString", "affectedInControlflow", "queryFunction","loopWhile","constStat","inputReaches","loopNestedDepth","inputAffectPath","inputAffectQuery","queryCardinality","redundantData","tableFieldFuncdep","closureCarryDep"]
YaxisLabel = {}
YaxisLabel["queryGeneral"] = "Average #Q in an action"
YaxisLabel["branch"] = "Average #branch in an action"
YaxisLabel["branchInView"] = "Average #branch in an action"
YaxisLabel["queryInView"] = "Average #Q in an action"
YaxisLabel["usedInView"] = "Average #readQ in an action"
YaxisLabel["usedSQLString"] = "Average #readQ in an action"
YaxisLabel["materialized"] = "Average #readQ returning full record in an action"
YaxisLabel["onlyFromUser"] = "Average #Q in an action"
YaxisLabel["inClosure"] = "Average #Q in an action"
YaxisLabel["readSink"] = "Average #sink node for each query"
YaxisLabel["readSource"] = "Average #source node for each query"
YaxisLabel["writeSource"] = "Average #source node for each query"
YaxisLabel["TableInView"] = "#tables"
YaxisLabel["FieldInView"] = "#fields from all tables"
YaxisLabel["transaction"] = "#Q in a transaction"
YaxisLabel["transactionNested"] = "#transactions added from all actions"
YaxisLabel["queryString"] = "Average used frequency in each read query"
YaxisLabel["queryFunction"] = "Average used frequency in each query"
YaxisLabel["constStat"] = "Average used frequency in each read query"
YaxisLabel["inputReaches"] = "Breakdown of input affecting % of queries"
YaxisLabel["tableStat"] = "Breakdown of #Q by tables in an action"
YaxisLabel["path"] = "Number of instructions"
YaxisLabel["loopNestedDepth"] = "average number of loop in each request"
YaxisLabel["queryCardinality"] = "average number of queries in each request"
YaxisLabel["inputAffectPath"] = "number of instructions"
YaxisLabel["inputAffectQuery"] = "number of queries"
YaxisLabel["tableFieldFuncdep"] = "number of fields"
YaxisLabel["selectCondition"] = "number of tables"
YaxisLabel["redundantData"] = "field size by byte"
YaxisLabel["longestQueryPath"] = "number of queries"
YaxisLabel["orderFunction"] = "percentage of order/non_order queries in each request"
YaxisLabel["orderField"] = "number of tables"
YaxisLabel["loopWhile"] = "avg number of loops in each request"
YaxisLabel["closureCarryDep"] = "avg number of queries in loop in each request"
YaxisLabel["assocQuery"] = "avg number of queries in each request"
YaxisLabel["affectedInControlflow"] = "avg number of queries in each request"

for s in stats:
	print "printing %s..."%s
	general_plot(s, YaxisLabel[s])

plot_field_stat("tableFieldStat")
plot_field_stat("nonFieldStat")
plot_table_stat("tableStat")

QP_stack = {}
QP_stack["longestQueryPathLoopCarry"] = 0
QP_stack["longestQueryPathLoopNoCarry"] = 0
QP_stack["longestQueryPathNotInLoop"] = 0
QP_stack["totalQueryNumber"] = 1
general_plot("longestQueryPath", YaxisLabel["longestQueryPath"], True, QP_stack)
general_plot("path", YaxisLabel["path"], True, {})
#exit(0)
#NA stands for NextAction
roots = {}
#app_string="lobsters amahiPlatform fulcrum boxroom rucksack sharetribe jobsworth publify enki wallgig railscollab tracks brevidy communityengine"
#app_string="fulcrum rucksack boxroom publify shoppe amahiPlatform enki wallgig lobsters communityengine"
app_string="fulcrum rucksack boxroom publify brevidy tracks lobsters communityengine linuxfr railscollab shoppe amahiPlatform enki wallgig"


applications = app_string.split(" ")

for app in applications:
	fname = "%s/nextaction_%s_stat.xml"%(result_path, app)
	tree = ET.parse(fname)
	roots[app] = tree.getroot()

general_plot("nextAction", "Average #Q in next action")


