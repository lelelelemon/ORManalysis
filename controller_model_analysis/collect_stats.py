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

base_path = "../applications/lobsters/results"

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
	return float(sum(l)) / float(len(l))

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("stats.xml"):
			fname = os.path.join(subdir, fn)
			tree = ET.parse(fname)
			roots.append(tree.getroot())

def remove_xticks(ax):
	ax.tick_params(
    axis='x',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='off',      # ticks along the bottom edge are off
    top='off',         # ticks along the top edge are off
    labelbottom='off') # labels along the bottom edge are off	

print "Root length : %d"%len(roots)
prefix1 = ["stat"]
general_stats_prefix = prefix1[:]
general_stats_prefix.append("general")
table_stats_content = ["queryTotal", "queryInView", "queryInClosure"]
general_stats_content = table_stats_content[:]
general_stats_content.append("branchOnQuery")
general_stats_content.append("branchTotal")

read_stats_content = ["total", "sinkTotal", "toReadQuery", "toWriteQuery", "toView", "toBranch"]

write_stats_content = ["total", "sourceTotal", "fromUserInput", "fromQuery", "fromConst"]

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
	data = {}
	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		data[g] = getAverage(r)
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
		print "%f, %d"%(writes[g], len(r))
	
	fig = plt.figure(figsize=(15, 7))
	#first bar: Qread + Qwrite = Qtotal
	ax1 = fig.add_subplot(161)
	rect1 = ax1.bar(range(1, 2), [reads["total"]], color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(range(1, 2), [writes["total"]], bottom=reads["total"], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("query total")
	ax1.set_ylabel("number of queries")
	ax1.set_xticklabels(('',''))
	ax1.legend((rect1[0], rect2[0]), ('read','write'),prop={'size':'12'}, loc='upper right')

	#second bar: queryInView
	ax2 = fig.add_subplot(162)
	ax2.bar(range(1, 2), [data["queryInView"]], color=tableau_colors[colors[2]])
	ax2.set_xlabel("query in view")
	ax2.set_ylabel("number of queries")

	#third bar: queryInClosure
	ax3 = fig.add_subplot(163)
	ax3.bar(range(1, 2), [data["queryInClosure"]], color=tableau_colors[colors[2]])
	ax3.set_xlabel("query in closure")
	ax3.set_ylabel("number of queries")

	#fourth bar: branchOnQuery + branchOther
	if plot_branch:
		ax4 = fig.add_subplot(164)
		rect1 = ax4.bar(range(1, 2), [data["branchOnQuery"]], color=tableau_colors[colors[3]], edgecolor='black')
		rect2 = ax4.bar(range(1, 2), [data["branchTotal"]-data["branchOnQuery"]], bottom=data["branchOnQuery"], color=tableau_colors[colors[4]], edgecolor='black')
		ax4.set_xlabel("branch total")
		ax4.set_ylabel("number of queries")
		ax4.legend((rect1[0], rect2[0]), ('branch depend on query','branch others'), prop={'size':'12'}, loc='upper right')

	#fifth bar: readSink
	ax5 = fig.add_subplot(165)
	sum1 = reads["toReadQuery"]
	sum2 = sum1 + reads["toWriteQuery"]
	sum3 = sum2 + reads["toBranch"]
	sum4 = sum3 + reads["toView"]
	rect1 = ax5.bar(range(1, 2), [reads["toReadQuery"]], color=tableau_colors[colors[5]])
	rect2 = ax5.bar(range(1, 2), [reads["toWriteQuery"]], bottom=sum1, color=tableau_colors[colors[6]])
	rect3 = ax5.bar(range(1, 2), [reads["toBranch"]], bottom=sum2, color=tableau_colors[colors[7]])
	rect4 = ax5.bar(range(1, 2), [reads["toView"]], bottom=sum3, color=tableau_colors[colors[8]])
	ax5.set_xlabel("read sink")
	ax5.set_ylabel("number of sink instr")
	ax5.legend((rect1[0], rect2[0], rect3[0], rect4[0]), ('to read query','to write query','to branch', 'to view'), prop={'size':'12'}, loc='upper right')
	#sixth bar: writeSource
	ax6 = fig.add_subplot(166)
	sum1 = writes["fromUserInput"]
	sum2 = sum1 + writes["fromQuery"]
	sum3 = sum2 + writes["fromConst"]
	rect1 = ax6.bar(range(1, 2), [writes["fromUserInput"]], color=tableau_colors[colors[5]])
	rect2 = ax6.bar(range(1, 2), [writes["fromQuery"]], bottom=sum1, color=tableau_colors[colors[6]])
	rect3 = ax6.bar(range(1, 2), [writes["fromConst"]], bottom=sum2, color=tableau_colors[colors[7]])
	ax6.set_xlabel("write source")
	ax6.set_ylabel("number of source instr")
	ax6.legend((rect1[0], rect2[0], rect3[0]), ('from user input','from query','from const'), prop={'size':'12'}, loc='upper right')

	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	plt.show()


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
def print_fields(prefix, content):
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
	ax.legend()
	plt.show()


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

	ax1 = fig.add_subplot(121)
	rect1 = ax1.bar(ind, [data["read"]["min"], data["read"]["max"]], width, color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax1.bar(ind, [data["write"]["min"], data["write"]["max"]], width, bottom=[data["read"]["min"], data["read"]["max"]], color=tableau_colors[colors[1]], edgecolor='black')
	ax1.set_xlabel("queries on a single path")
	ax1.set_ylabel("number of queries")
	ax1.set_xticklabels(('min','max'))
	ax1.legend((rect1[0], rect2[0]), ('read','write'),prop={'size':'12'}, loc='upper right')

	ind = np.arange(1)
	ax2 = fig.add_subplot(122)
	rect1 = ax2.bar(ind, [data["shortestPath"]], width, color=tableau_colors[colors[2]], edgecolor='black')
	rect2 = ax2.bar(ind+width, [data["longestPath"]], width, color=tableau_colors[colors[3]], edgecolor='black')
	rect3 = ax2.bar(ind+width*2, [data["instrTotal"]], width, color=tableau_colors[colors[4]], edgecolor='black')

	#rect1 = ax2.bar(range(1, 2), [data["shortestPath"], data["longestPath"], data["instrTotal"]], color=tableau_colors[colors[2], colors[3], colors[4]], edgecolor='black')
	ax2.set_xlabel("path length")
	ax2.set_ylabel("number of instructions")
	ax2.set_xticklabels(('shortestPath','longestPath', 'ignorePathTotal'))
	
	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	plt.show()

#print_general_stat(general_stats_prefix, general_stats_content, True)
#print_fields(nonfield_prefix, field_stats_content)
print_path(prefix3, path_stats_content+path_stats_content2)
