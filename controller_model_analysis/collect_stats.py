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

roots = []
app_name = sys.argv[1]

base_path = "../applications/%s/results"%app_name
fig_path = "../applications/%s/figs"%app_name

if os.path.isdir(fig_path) == False:
	os.system("mkdir %s"%fig_path)

tablename_file = "../applications/%s/table_name.txt"%app_name
tablefield_file = "../applications/%s/tablefields.txt"%app_name
tablename_fp = open(tablename_file)
tablefield_fp = open(tablefield_file)
tables = []
for line in tablename_fp:
	line = line.replace("\n", "")
	tables.append(line)
tables.sort()
tablefields = []
for line in tablefield_fp:
	line = line.replace("\n", "")
	tablefields.append(line)


def calculateAverageRecursive(cond_list, pos, node, to_float):
	results = []
	for child in node:
		if child.tag == cond_list[pos]:
			if pos ==  len(cond_list)-1:
				if to_float:
					if child.text == "NaN":
						results.append(-1)
					else:
						results.append(float(child.text))
				else:
					results.append(child.text)
			else:
				results = results + calculateAverageRecursive(cond_list, pos+1, child, to_float)
	return results

def calculateAllActions(cond_list, to_float=True):
	result = []
	for root in roots:
		result = result + calculateAverageRecursive(cond_list, 0, root, to_float)
	return result

def getAverage(l):
	if len(l)==0:
		return 0.0
	else:
		return float(sum(l)) / float(len(l))

#preprocess
for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("stats.xml"):
			fname = os.path.join(subdir, fn)
			f = open(fname,'r')
			filedata = f.read()
			f.close()
			newdata = filedata.replace("::","")
			f = open(fname,'w+')
			f.write(newdata)
			f.close()

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("stats.xml"):
			fname = os.path.join(subdir, fn)
			tree = ET.parse(fname)
			roots.append(tree.getroot())


print "Root length : %d"%len(roots)

table_names = ["general"]
for root in roots:
	if root[0].tag == "stat":
		c = root[0]
		#for child in c:
			#if child.tag not in table_names:
				#table_names.append(child.tag)
				#print "Table: %s"%child.tag


prefix1 = ["stat"]
general_stats_prefix = prefix1[:]
table_stats_prefix = prefix1[:]  
general_stats_prefix.append("general")
table_stats_content = ["queryTotal", "queryInView", "queryInClosure", "queryOnlyFromUser", "queryUsedInView"]
general_stats_content = table_stats_content[:]
general_stats_content.append("branchOnQuery")
general_stats_content.append("branchTotal")
                                 
read_stats_content = ["total", "sinkTotal", "toReadQuery", "toWriteQuery", "toView", "toBranch"]
                                 
write_stats_content = ["total", "sourceTotal", "fromUserInput", "fromQuery", "fromConst"]
                                 
view_stat_prefix = ["viewStats"] 
clique_stat_prefix = ["cliqueStat"]

prefix2 = ["chainStats"]
field_prefix = prefix2[:]
field_prefix.append("field")
nonfield_prefix = prefix2[:]
nonfield_prefix.append("nonField")
chain_stats_content = ["length", "outNodes", "inNodes", "outSinks", "inSources"]
input_stats_content = ["inputReaches"]
field_stats_content = ["name", "numUses", "numAssigns", "type", "avgSourceDist"]

prefix3 = ["singlePath"]
path_stats_content = ["total", "read", "write"]
path_stats_content2 = ["shortestPath", "longestPath", "instrTotal"]

colors = [5,2,7,9,3,4,10,12,13]	

# stats
def print_general_stat(prefix, content, plot_branch):
	print "pref =:"
	print prefix
	data = {}
	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		print cond_list
		r = calculateAllActions(cond_list)
		data[g] = getAverage(r)

	print data["queryTotal"]
	reads = {}
	for g in read_stats_content:
		cond_list = prefix[:]
		cond_list.append("read")
		cond_list.append(g)
		print cond_list
		r = calculateAllActions(cond_list)
		reads[g] = getAverage(r)

	writes = {}
	for g in write_stats_content:
		cond_list = prefix[:]
		cond_list.append("write")
		cond_list.append(g)
		print cond_list
		r = calculateAllActions(cond_list)
		writes[g] = getAverage(r)
		#print "%f, %d"%(writes[g], len(r))

	print "queryTotal:\t%f"%data["queryTotal"]
	print "read:\t%f"%reads["total"]
	print "write:\t%f"%writes["total"]
	print "branch:\t%f\t%f"%(data["branchOnQuery"], data["branchTotal"])
	print "usedInView:\t%f"%data["queryUsedInView"]
	print "onlyFromUser:\t%f"%data["queryOnlyFromUser"]

	print "READsink:\t%f\t%f\t%f\t%f"%(reads["toReadQuery"], reads["toWriteQuery"], reads["toBranch"], reads["toView"])
	print "WRITEsource:\t%f\t%f\t%f"%(writes["fromQuery"], writes["fromUserInput"], writes["fromConst"])
	ind = np.arange(1)
	width = 0.2
	
	fig = plt.figure(figsize=(15, 7))
	#first bar: Qread + Qwrite = Qtotal
	ax1 = fig.add_subplot(151)
	ax1.set_ylim(0, data["queryTotal"]*1.4)
	rect1 = ax1.bar(ind, [reads["total"]], color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [writes["total"]], bottom=reads["total"], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("query total")
	ax1.set_ylabel("number of queries")
	ax1.set_xticklabels((''))
	ax1.legend((rect1[0], rect2[0]), ('read','write'),prop={'size':'10'}, loc='upper right')

	#second bar: queryInView
	ax2 = fig.add_subplot(152)
	ax2.set_ylim(0, data["queryTotal"]*1.4)
	ax2.bar(range(1, 2), [data["queryInView"]], color=tableau_colors[colors[2]])
	ax2.set_xticklabels((''))
	ax2.set_xlabel("query in view")
	ax2.set_ylabel("number of queries")

	#third bar: queryInClosure
	ax3 = fig.add_subplot(153)
	ax3.set_ylim(0, data["queryTotal"]*1.4)
	ax3.bar(range(1, 2), [data["queryInClosure"]], color=tableau_colors[colors[2]])
	ax3.set_xticklabels((''))
	ax3.set_xlabel("query in closure")
	ax3.set_ylabel("number of queries")

	#fourth bar: query Only from user input	/ const
	ax1 = fig.add_subplot(154)
	ax1.set_ylim(0, data["queryTotal"]*1.4)
	rect1 = ax1.bar(ind, [data["queryOnlyFromUser"]], color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [data["queryTotal"]-data["queryOnlyFromUser"]], bottom=[data["queryOnlyFromUser"]], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("Q use results from other Qs")
	ax1.set_ylabel("number of queries")
	ax1.set_xticklabels((''))
	ax1.legend((rect1[0], rect2[0]), ('from input/const','from other queries'),prop={'size':'10'}, loc='upper right')

	#fifth bar: query used in view
	ax1 = fig.add_subplot(155)
	ax1.set_ylim(0, data["queryTotal"]*1.4)
	data["queryUsedInView"] += 1.2
	rect1 = ax1.bar(ind, [data["queryUsedInView"]], color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [reads["total"]-data["queryUsedInView"]], bottom=[data["queryUsedInView"]], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("Q results used in view")
	ax1.set_ylabel("number of queries")
	ax1.set_xticklabels((''))
	ax1.legend((rect1[0], rect2[0]), ('result used in view','result not used in view'),prop={'size':'10'}, loc='upper right')


	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	print "%s/querystat_%s.png"%(fig_path, prefix[-1])
	fig.savefig("%s/querystat_%s.png"%(fig_path, prefix[-1]))
	plt.close(fig)
	fig = plt.figure()


	#2.1 bar: branchOnQuery + branchOther
	if plot_branch:
		ax4 = fig.add_subplot(131)
		rect1 = ax4.bar(range(1, 2), [data["branchOnQuery"]], width, color=tableau_colors[colors[3]], edgecolor='black')
		rect2 = ax4.bar(range(1, 2), [data["branchTotal"]-data["branchOnQuery"]], width, bottom=data["branchOnQuery"], color=tableau_colors[colors[4]], edgecolor='black')
		ax4.set_xticklabels((''))
		ax4.set_ylim(0, data["branchTotal"]*1.4)
		ax4.set_xlabel("branch total")
		ax4.set_ylabel("number of queries")
		ax4.legend((rect1[0], rect2[0]), ('branch depend on query','branch others'), prop={'size':'10'}, loc='upper right')

	#2.2 bar: readSink
	ax5 = fig.add_subplot(132)
	sum1 = reads["toReadQuery"]
	sum2 = sum1 + reads["toWriteQuery"]
	sum3 = sum2 + reads["toBranch"]
	sum4 = sum3 + reads["toView"]
	ax5.set_ylim(0, sum4*1.4/float(reads["total"]))
	rect1 = ax5.bar(ind, [reads["toReadQuery"]/float(reads["total"])], width, color=tableau_colors[colors[5]])
	rect2 = ax5.bar(ind, [reads["toWriteQuery"]/float(reads["total"])], width, bottom=[sum1/float(reads["total"])], color=tableau_colors[colors[6]])
	rect3 = ax5.bar(ind, [reads["toBranch"]/float(reads["total"])], width, bottom=[sum2/float(reads["total"])], color=tableau_colors[colors[7]])
	rect4 = ax5.bar(ind, [reads["toView"]/float(reads["total"])], width, bottom=[sum3/float(reads["total"])], color=tableau_colors[colors[8]])
	ax5.set_xticklabels((''))
	ax5.set_xlabel("read sink")
	ax5.set_ylabel("number of sink instr")
	ax5.legend((rect1[0], rect2[0], rect3[0], rect4[0]), ('to read query','to write query','to branch', 'to view'), prop={'size':'10'}, loc='upper right')
	
	#2.3 bar: writeSource
	ax6 = fig.add_subplot(133)
	sum1 = writes["fromUserInput"]
	sum2 = sum1 + writes["fromQuery"]
	sum3 = sum2 + writes["fromConst"]
	ax6.set_ylim(0, sum3*1.4/float(writes["total"]))
	rect1 = ax6.bar(ind, [writes["fromUserInput"]/float(writes["total"])], width, color=tableau_colors[colors[5]])
	rect2 = ax6.bar(ind, [writes["fromQuery"]/float(writes["total"])], width, bottom=[sum1/float(writes["total"])], color=tableau_colors[colors[6]])
	rect3 = ax6.bar(ind, [writes["fromConst"]/float(writes["total"])], width, bottom=[sum2/float(writes["total"])], color=tableau_colors[colors[7]])
	ax6.set_xticklabels((''))
	ax6.set_xlabel("write source")
	ax6.set_ylabel("number of source instr")
	ax6.legend((rect1[0], rect2[0], rect3[0]), ('from user input','from query','from const'), prop={'size':'10'}, loc='upper right')

	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	print "%s/querystat_%s2.png"%(fig_path, prefix[-1])
	fig.savefig("%s/querystat_%s2.png"%(fig_path, prefix[-1]))
	plt.close(fig)
	#plt.show()

def print_view_stat(prefix):
	table = []
	field = []
	cond_list = prefix[:]
	cond_list.append("table")
	r = calculateAllActions(cond_list, False)
	for t in r:
		if t not in table:
			table.append(t)
	table.sort()
	print "Table used in view:"
	for t in table:
		print "%s, "%t,
	print ""
 	print "Table all:"
	for t in tables:
		print "%s, "%t,

	print ""
	print "Table Used in view:\t%d\t%d"%(len(table), len(tables))
	ind = np.arange(1)
	width = 0.2
	
	fig = plt.figure()

	ax1 = fig.add_subplot(121)
	ax1.set_ylim(0, len(tables)*1.4)
	rect1 = ax1.bar(ind, [len(table)], width, color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [len(tables)-len(table)], width, bottom=[len(table)], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("% of tables presented in view")
	ax1.set_ylabel("number of tables")
	ax1.set_xticklabels((''))
	ax1.legend((rect1[0], rect2[0]), ('table presented in view','table not presented in view'),prop={'size':'10'}, loc='upper right')

	cond_list = prefix[:]
	cond_list.append("field")
	r = calculateAllActions(cond_list, False)
	for t in r:
		if t not in field:
			field.append(t)

	ax2 = fig.add_subplot(122)
	ax2.set_ylim(0, len(tablefields)*1.4)
	rect1 = ax2.bar(ind, [len(field)], width, color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax2.bar(ind, [len(tablefields)-len(field)], width, bottom=[len(field)], color=tableau_colors[colors[1]], edgecolor='black')
	ax2.set_xlabel("% of fields presented in view")
	ax2.set_ylabel("number of total fields")
	ax2.set_xticklabels((''))
	ax2.legend((rect1[0], rect2[0]), ('fields showed in view','fields not showed in view'),prop={'size':'10'}, loc='upper right')
	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)

	print "Field used in view:\t%d\t%d"%(len(field), len(tablefields))
	fig.savefig("%s/view_stat.png"%(fig_path))


#chain
def print_chain(prefix, content):
	data = {}
	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		data[g] = getAverage(r)
	print "chain stats:"
	for k,v in data.items():
		print "\t%s: %f"%(k, v)

#fields
def print_fields(prefix, content, non_field=False):
	data = {}
	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		if g == "name" or g == "type":
			data[g] = calculateAllActions(cond_list, False)
		else:
			data[g] = calculateAllActions(cond_list)
	#aggregate by data["type"]
	agg_by_type = {}
	for i in range(len(data["type"])):
		n = data["type"][i]
		if n not in agg_by_type:
			agg_by_type[n] = {}
			agg_by_type[n] = {}
		f_name = data["name"][i]
		if f_name not in agg_by_type[n]:
			agg_by_type[n][f_name] = {}
			agg_by_type[n][f_name]["numUses"] = []
			agg_by_type[n][f_name]["avgSourceDist"] = []
		agg_by_type[n][f_name]["numUses"].append(data["numUses"][i])
		agg_by_type[n][f_name]["avgSourceDist"].append(data["avgSourceDist"][i])
	
	legend = []
	legend_name = []
	fig = plt.figure()
	ax = fig.add_subplot(111)	
	i = 0
	for k,v in agg_by_type.items():
		plt_data = []
		plt_data.append([])
		plt_data.append([])
		for k1, v1 in v.items(): #k1 = class_name.field_name, v1 = {"numUses","avgS"}
			plt_data[0].append(getAverage(v1["numUses"]))
			plt_data[1].append(getAverage(v1["avgSourceDist"]))
		l = ax.scatter(plt_data[0], plt_data[1], color=tableau_colors[i%TOTAL_COLOR_NUM], label=k)
		#legend_name.append(k)
		#legend.append(l[0])
		i = i + 1
	#ax.legend(legend, legend_name) 
	ax.legend(bbox_to_anchor=(1.05, 1.05), prop={'size':'10'})
	#plt.show()
	if non_field:
		fig.savefig("%s/notstored_field.png"%(fig_path))
	else:
		fig.savefig("%s/table_field.png"%(fig_path))
	plt.close(fig)

def print_clique_stat(prefix):
	validation = []
	clique = []
	cond_list = prefix[:]
	cond_list.append("validation")
	r = calculateAllActions(cond_list)
	validation = validation + r
	cond_list = prefix[:]
	cond_list.append("clique")
	r = calculateAllActions(cond_list)
	clique = clique + r
	print "Average validation length:\t%f\t%d validations"%(getAverage(validation), len(validation))
	print "Average clique size:\t%f\tnumber\t%d"%(getAverage(clique), len(clique)) 


#path
def print_path(prefix, content):
	data = {}
	fig = plt.figure(figsize=(8, 4))

	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		if g == "total" or g == "read" or g == "write":	
			data[g] = {}
			cond_list.append("min")
			r = calculateAllActions(cond_list)
			data[g]["min"] = getAverage(r)
			cond_list[-1] = "max"
			r = calculateAllActions(cond_list)
			data[g]["max"] = getAverage(r)
		else:
			r = calculateAllActions(cond_list)
			data[g] = getAverage(r)

	ind = np.arange(2)
	width = 0.2

	print "path:\t%f\t%f\t%f"%(data["shortestPath"], data["longestPath"], data["instrTotal"])
	ax1 = fig.add_subplot(121)
	rect1 = ax1.bar(ind, [data["read"]["min"], data["read"]["max"]], width, color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [data["write"]["min"], data["write"]["max"]], width, bottom=[data["read"]["min"], data["read"]["max"]], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("queries on a single path")
	ax1.set_ylabel("number of queries")
	ax1.set_xticks(ind + width/2)
	ax1.set_xticklabels(('min','max'))
	ax1.legend((rect1[0], rect2[0]), ('read','write'),prop={'size':'12'}, loc='upper left')

	ind = np.arange(1)
	ax2 = fig.add_subplot(122)
	rect1 = ax2.bar(ind, [data["shortestPath"]], width, color=tableau_colors[colors[2]], edgecolor='black')
	rect2 = ax2.bar(ind+width, [data["longestPath"]], width, color=tableau_colors[colors[3]], edgecolor='black')
	rect3 = ax2.bar(ind+width*2, [data["instrTotal"]], width, color=tableau_colors[colors[4]], edgecolor='black')

	#rect1 = ax2.bar(ind, [data["shortestPath"], data["longestPath"], data["instrTotal"]], color=tableau_colors[colors[2], colors[3], colors[4]], edgecolor='black')
	ax2.set_xlabel("path length")
	ax2.set_ylabel("number of instructions")
	#ax2.set_xticks(ind + width/2)
	#ax2.set_xticklabels(('shortestPath','longestPath','ignorePathTotal'))
	ax2.set_xticklabels((''))
	ax2.legend((rect1[0], rect2[0], rect3[0]), ('shortest_Path', 'longestPath', 'ignorePathTotal'), loc='upper left', prop={'size':'10'})
	
	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	#plt.show()
	fig.savefig("%s/path.png"%(fig_path))



#print_general_stat(general_stats_prefix, general_stats_content, True)
for table in table_names:
	pref = table_stats_prefix[:]
	pref.append(table)
	if table == "general":
		print_general_stat(pref, general_stats_content, True)
	else:
		print_general_stat(pref, table_stats_content, False)

print_fields(nonfield_prefix, field_stats_content, True)
print_fields(field_prefix, field_stats_content)
print_path(prefix3, path_stats_content+path_stats_content2)

print_view_stat(view_stat_prefix)
print_clique_stat(clique_stat_prefix)
