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

stats_file_path = sys.argv[2]
stats_file = open(stats_file_path, 'w')

base_path = "../applications/%s/results"%app_name
fig_path = "../applications/%s/figs"%app_name

if os.path.isdir(fig_path) == False:
	os.system("mkdir %s"%fig_path)
else:
	os.system("rm -rf %s"%fig_path)
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
			print fname
			tree = ET.parse(fname)
			roots.append(tree.getroot())


stats_file.write("<%s>\n"%app_name)
stats_file.write("\t<RootLength>%d</RootLength>\n"%len(roots))

#table_names = ["general"]
table_names = []
for root in roots:
	if root[0].tag == "stat":
		c = root[0]
		for child in c:
			if child.tag not in table_names and child.tag != "general":
				table_names.append(child.tag)
				print "Table: %s"%child.tag


prefix1 = ["stat"]
general_stats_prefix = prefix1[:]
table_stats_prefix = prefix1[:]  
general_stats_prefix.append("general")
table_stats_content = ["queryTotal", "queryInView", "queryInClosure", "queryUseSQLString", "queryOnlyFromUser", "queryUsedInView"]
general_stats_content = table_stats_content[:]
general_stats_content.append("branchOnQuery")
general_stats_content.append("branchInView")
general_stats_content.append("branchTotal")
general_stats_content.append("queryToTrivialBranch")
general_stats_content.append("trivialBranch")
                                 
read_stats_content = ["total", "sinkTotal", "toReadQuery", "toWriteQuery", "toView", "toBranch"]
                                 
write_stats_content = ["total", "sourceTotal", "fromUserInput", "fromQuery", "fromConst", "fromQueryString", "selectCondition", "fromUtil", "fromGlobal"]
                                 
view_stat_prefix = ["viewStats"] 
clique_stat_prefix = ["cliqueStat"]
schema_stat_prefix = ["schema"]

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

colors = [5,2,7,9,3,4,10,12,13,15,16]	

def print_table_query_stat(prefix):
	data = {}
	stats_file.write("\t<tableStat>\n")

	for table in table_names:
		cond_list = table_stats_prefix[:]
		cond_list.append(table)
		cond_list.append("queryTotal")
		print cond_list
		r = calculateAllActions(cond_list)
		stats_file.write("\t\t<%s>%f</%s>\n"%(table, sum(r), table))	
	
	stats_file.write("\t</tableStat>\n")

# stats
def print_general_stat(prefix, content, plot_branch, plot_read_source):
	data = {}
	for g in content:
		cond_list = prefix[:]
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		data[g] = getAverage(r)

	reads = {}
	read_sum = 0
	for g in read_stats_content:
		cond_list = prefix[:]
		cond_list.append("readSink")
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		if g == "total":
			reads[g] = getAverage(r)
			read_sum = sum(r)
		else:
			reads[g] = float(sum(r))/float(read_sum)
		#reads[g] = getAverage(r)

	readSource = {}
	read_sum = 0
	for g in write_stats_content:
		cond_list = prefix[:]
		cond_list.append("readSource")
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		if g == "total":
			readSource[g] = getAverage(r)
			read_sum = sum(r)
		else:
			readSource[g] = float(sum(r))/float(read_sum)
		#readSource[g] = getAverage(r)

	writes = {}
	write_sum = 0
	for g in write_stats_content:
		cond_list = prefix[:]
		cond_list.append("writeSource")
		cond_list.append(g)
		r = calculateAllActions(cond_list)
		if g == "total":
			writes[g] = getAverage(r)
			write_sum = sum(r)
		else:
			writes[g] = float(sum(r))/float(write_sum)
		#writes[g] = getAverage(r)
		#print "%f, %d"%(writes[g], len(r))


	stats_file.write("\t<queryGeneral>\n")
	stats_file.write("\t\t<readQuery>%f</readQuery>\n"%reads["total"])
	stats_file.write("\t\t<writeQuery>%f</writeQuery>\n"%writes["total"])
	stats_file.write("\t</queryGeneral>\n")

	stats_file.write("\t<branch>\n")
	stats_file.write("\t\t<trivialBranch>%f</trivialBranch>\n"%data["trivialBranch"])
	stats_file.write("\t\t<onQueryOther>%f</onQueryOther>\n"%(data["branchOnQuery"]-data["trivialBranch"]))
	stats_file.write("\t\t<notOnQuery>%f</notOnQuery>\n"%(data["branchTotal"]-data["branchOnQuery"]))
	stats_file.write("\t</branch>\n")

	stats_file.write("\t<branchInView>\n")
	stats_file.write("\t\t<branchInView>%f</branchInView>\n"%(data["branchInView"]))
	stats_file.write("\t\t<branchNotInView>%f</branchNotInView>\n"%(data["branchTotal"]-data["branchInView"]))
	stats_file.write("\t</branchInView>\n")

	stats_file.write("\t<usedInView>\n")
	stats_file.write("\t\t<queryResultUsedInView>%f</queryResultUsedInView>\n"%data["queryUsedInView"])
	stats_file.write("\t\t<queryResultNotUsedInView>%f</queryResultNotUsedInView>\n"%(reads["total"]-data["queryUsedInView"]))
	stats_file.write("\t</usedInView>\n")

	stats_file.write("\t<usedSQLString>\n")
	stats_file.write("\t\t<queryUseSQLString>%f</queryUseSQLString>\n"%data["queryUseSQLString"])
	stats_file.write("\t\t<queryNotUseSQLString>%f</queryNotUseSQLString>\n"%(reads["total"]+writes["total"]-data["queryUseSQLString"]))
	stats_file.write("\t</usedSQLString>\n")

	stats_file.write("\t<onlyFromUser>\n")
	stats_file.write("\t\t<queryOnlyUseOtherSource>%f</queryOnlyUseOtherSource>\n"%data["queryOnlyFromUser"])
	stats_file.write("\t\t<queryUseQueryResults>%f</queryUseQueryResults>\n"%(reads["total"]-data["queryOnlyFromUser"]))
	stats_file.write("\t</onlyFromUser>\n")

	stats_file.write("\t<inClosure>\n")
	stats_file.write("\t\t<queryInClosure>%f</queryInClosure>\n"%data["queryInClosure"])
	stats_file.write("\t\t<queryNotInClosure>%f</queryNotInClosure>\n"%(data["queryTotal"]-data["queryInClosure"]))
	stats_file.write("\t</inClosure>\n")

	stats_file.write("\t<queryTrivialBranch>\n")
	stats_file.write("\t\t<queryToTrivialBranch>%f</queryToTrivialBranch>\n"%data["queryToTrivialBranch"])
	stats_file.write("\t\t<queryToOthers>%f</queryToOthers>\n"%(reads["total"]-data["queryToTrivialBranch"]))
	stats_file.write("\t</queryTrivialBranch>\n")


	stats_file.write("\t<readSink>\n")
	temp_total = 0
	for k in read_stats_content:
		if k != "sinkTotal" and k != "total":
			temp_total += reads[k]
			stats_file.write("\t\t<%s>%f</%s>\n"%(k,reads[k],k))
	#stats_file.write("\t\t<other>%f</other>\n"%(reads["sinkTotal"]-temp_total))
	stats_file.write("\t</readSink>\n")


	stats_file.write("\t<readSource>\n")
	temp_total = 0
	for k in write_stats_content:
		if k != "sourceTotal" and k != "total":
			temp_total += readSource[k]
			stats_file.write("\t\t<%s>%f</%s>\n"%(k,readSource[k],k))
	#stats_file.write("\t\t<other>%f</other>\n"%(readSource["sourceTotal"]-temp_total))
	stats_file.write("\t</readSource>\n")

	stats_file.write("\t<writeSource>\n")
	temp_total = 0
	for k in write_stats_content:
		if k != "sourceTotal" and k != "total":
			temp_total += writes[k]
			stats_file.write("\t\t<%s>%f</%s>\n"%(k,writes[k],k))
	#stats_file.write("\t\t<other>%f</other>\n"%(writes["sourceTotal"]-temp_total))
	stats_file.write("\t</writeSource>\n")
	

	#print "READsink:\t%f\t:\t%f\t%f\t%f\t%f"%(reads["sinkTotal"], reads["toReadQuery"], reads["toWriteQuery"], reads["toBranch"], reads["toView"])
	#print "READsource:\t%f\t:\t%f\t%f\t%f\t%f"%(readSource["sourceTotal"], readSource["fromQuery"], readSource["fromUserInput"], readSource["fromConst"], readSource["fromUtil"])
	#print "WRITEsource:\t%f\t:\t%f\t%f\t%f\t%f"%(writes["sourceTotal"], writes["fromQuery"], writes["fromUserInput"], writes["fromConst"], writes["fromUtil"])
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
	#print "%s/querystat_%s.png"%(fig_path, prefix[-1])
	fig.savefig("%s/querystat_%s.pdf"%(fig_path, prefix[-1]))
	plt.close(fig)
	fig = plt.figure()


	#2.1 bar: branchOnQuery + branchOther
	if plot_branch:
		ax4 = fig.add_subplot(141)
		rect1 = ax4.bar(range(1, 2), [data["branchOnQuery"]], width, color=tableau_colors[colors[3]], edgecolor='black')
		rect2 = ax4.bar(range(1, 2), [data["branchTotal"]-data["branchOnQuery"]], width, bottom=data["branchOnQuery"], color=tableau_colors[colors[4]], edgecolor='black')
		ax4.set_xticklabels((''))
		ax4.set_ylim(0, data["branchTotal"]*1.4)
		ax4.set_xlabel("branch total")
		ax4.set_ylabel("number of queries")
		ax4.legend((rect1[0], rect2[0]), ('branch depend on query','branch others'), prop={'size':'10'}, loc='upper right')

	#2.2 bar: readSink
	ax5 = fig.add_subplot(142)
	sum1 = reads["toReadQuery"]
	sum2 = sum1 + reads["toWriteQuery"]
	sum3 = sum2 + reads["toBranch"]
	sum4 = sum3 + reads["toView"]
	ax5.set_ylim(0, reads["sinkTotal"]*1.4)
	rect1 = ax5.bar(ind, [reads["toReadQuery"]], width, color=tableau_colors[colors[5]])
	rect2 = ax5.bar(ind, [reads["toWriteQuery"]], width, bottom=[sum1], color=tableau_colors[colors[6]])
	rect3 = ax5.bar(ind, [reads["toBranch"]], width, bottom=[sum2], color=tableau_colors[colors[7]])
	rect4 = ax5.bar(ind, [reads["toView"]], width, bottom=[sum3], color=tableau_colors[colors[8]])
	rect5 = ax5.bar(ind, [reads["sinkTotal"]-sum4], width, bottom=[sum4], color=tableau_colors[colors[9]])
	ax5.set_xticklabels((''))
	ax5.set_xlabel("read sink")
	ax5.set_ylabel("number of sinks")
	ax5.legend((rect1[0], rect2[0], rect3[0], rect4[0], rect5[0]), ('to read query','to write query','to branch', 'to view', 'other'), prop={'size':'10'}, loc='upper right')

	if plot_read_source:
		#2.3 bar: readSource
		ax6 = fig.add_subplot(143)
		sum1 = readSource["fromUserInput"]
		sum2 = sum1 + readSource["fromQuery"]
		sum3 = sum2 + readSource["fromConst"]
		sum4 = sum3 + readSource["fromUtil"]
		sum5 = sum4 + readSource["fromGlobal"]
		ax6.set_ylim(0, readSource["sourceTotal"]*1.4)
		rect1 = ax6.bar(ind, [readSource["fromUserInput"]], width, color=tableau_colors[colors[5]])
		rect2 = ax6.bar(ind, [readSource["fromQuery"]], width, bottom=[sum1], color=tableau_colors[colors[6]])
		rect3 = ax6.bar(ind, [readSource["fromConst"]], width, bottom=[sum2], color=tableau_colors[colors[7]])
		rect4 = ax6.bar(ind, [readSource["fromUtil"]], width, bottom=[sum3], color=tableau_colors[colors[8]])
		rect5 = ax6.bar(ind, [readSource["fromGlobal"]], width, bottom=[sum4], color=tableau_colors[colors[9]])
		rect6 = ax6.bar(ind, [readSource["sourceTotal"]-sum5], width, bottom=[sum5], color=tableau_colors[colors[10]])
		ax6.set_xticklabels((''))
		ax6.set_xlabel("read source")
		ax6.set_ylabel("number of sources")
		ax6.legend((rect1[0], rect2[0], rect3[0], rect4[0], rect5[0], rect6[0]), ('from user input','from query','from const','from util','from global var','other'), prop={'size':'10'}, loc='upper right')


	#2.4 bar: writeSource
	ax7 = fig.add_subplot(144)
	sum1 = writes["fromUserInput"]
	sum2 = sum1 + writes["fromQuery"]
	sum3 = sum2 + writes["fromConst"]
	sum4 = sum3 + writes["fromUtil"]
	sum5 = sum4 + writes["fromGlobal"]
	ax7.set_ylim(0, writes["sourceTotal"]*1.4)
	rect1 = ax7.bar(ind, [writes["fromUserInput"]], width, color=tableau_colors[colors[5]])
	rect2 = ax7.bar(ind, [writes["fromQuery"]], width, bottom=[sum1], color=tableau_colors[colors[6]])
	rect3 = ax7.bar(ind, [writes["fromConst"]], width, bottom=[sum2], color=tableau_colors[colors[7]])
	rect4 = ax7.bar(ind, [writes["fromUtil"]], width, bottom=[sum3], color=tableau_colors[colors[8]])
	rect5 = ax7.bar(ind, [writes["fromGlobal"]], width, bottom=[sum4], color=tableau_colors[colors[9]])
	rect6 = ax7.bar(ind, [writes["sourceTotal"]-sum5], width, bottom=[sum5], color=tableau_colors[colors[10]])
	ax7.set_xticklabels((''))
	ax7.set_xlabel("write source")
	ax7.set_ylabel("number of sources")
	ax7.legend((rect1[0], rect2[0], rect3[0], rect4[0], rect5[0], rect6[0]), ('from user input','from query','from const','from util','from global var','other'), prop={'size':'10'}, loc='upper right')

	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
	#print "%s/querystat_%s2.png"%(fig_path, prefix[-1])
	fig.savefig("%s/querystat_%s2.pdf"%(fig_path, prefix[-1]))
	plt.close(fig)
	#plt.show()

def print_view_stat(prefix):
	table = []
	field = []
	cond_list = prefix[:]
	cond_list.append("table")
	r = calculateAllActions(cond_list, False)
	for t in r:
		if t not in table and t not in ["boolean","integer","None"]:
			table.append(t)

	cond_list = prefix[:]
	cond_list.append("field")
	r = calculateAllActions(cond_list, False)
	for t in r:
		if t not in field:
			field.append(t)
			p = t.split('.')
			if p[0] not in table and p[0] not in ["boolean","integer","None"]:
				table.append(p[0])

	table.sort()
	print "Table used in view:"
	for t in table:
		print "%s, "%t,
	print ""
 	print "Table all:"
	for t in tables:
		print "%s, "%t,

	#print "Table Used in view:\t%d\t%d"%(len(table), len(tables))
	stats_file.write("\t<TableInView>\n")
	stats_file.write("\t\t<tableUsedInView>%d</tableUsedInView>\n"%len(table))
	stats_file.write("\t\t<tableNotUsedInView>%d</tableNotUsedInView>\n"%(len(tables)-len(table)))
	stats_file.write("\t</TableInView>\n")
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


	ax2 = fig.add_subplot(122)
	ax2.set_ylim(0, len(tablefields)*1.4)
	rect1 = ax2.bar(ind, [len(field)], width, color=tableau_colors[colors[0]], edgecolor='black')
	rect2 = ax2.bar(ind, [len(tablefields)-len(field)], width, bottom=[len(field)], color=tableau_colors[colors[1]], edgecolor='black')
	ax2.set_xlabel("% of fields presented in view")
	ax2.set_ylabel("number of total fields")
	ax2.set_xticklabels((''))
	ax2.legend((rect1[0], rect2[0]), ('fields showed in view','fields not showed in view'),prop={'size':'10'}, loc='upper right')
	plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)

	#print "Field used in view:\t%d\t%d"%(len(field), len(tablefields))
	stats_file.write("\t<FieldInView>\n")
	stats_file.write("\t\t<fieldUsedInView>%d</fieldUsedInView>\n"%(len(field)))
	stats_file.write("\t\t<fieldNotUsedInView>%d</fieldNotUsedInView>\n"%(len(tablefields)-len(field)))
	stats_file.write("\t</FieldInView>\n")
	fig.savefig("%s/view_stat.pdf"%(fig_path))


#chain
def print_chain(prefix, content):
	data = []
	cond_list = prefix[:]
	cond_list.append("inputReaches")
	data = calculateAllActions(cond_list)
	#data = getAverage(r)
	#print "chain stats:"
	#for k,v in data.items():
		#print "\t%s: %f"%(k, v)
	#input hist
	if len(data)>0:
		fig = plt.figure()
		ax1 = fig.add_subplot(111)
		rects = ax1.hist(data, bins=np.arange(min(data), max(data) + 5, 5))

		#plt.show()
		fig.savefig("%s/inputReachQuery.pdf"%(fig_path))


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
			agg_by_type[n][f_name]["numAssigns"] = []
			agg_by_type[n][f_name]["avgSourceDist"] = []
		agg_by_type[n][f_name]["numAssigns"].append(data["numAssigns"][i])
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
			plt_data[0].append(sum(v1["numAssigns"]))
			plt_data[1].append(getAverage(v1["avgSourceDist"]))
		l = ax.scatter(plt_data[0], plt_data[1], color=tableau_colors[i%TOTAL_COLOR_NUM], label=k)
		#legend_name.append(k)
		#legend.append(l[0])
		i = i + 1
	#ax.legend(legend, legend_name)
	ax.set_xlabel("Total: %d Actions"%len(roots)) 
	ax.legend(bbox_to_anchor=(1.05, 1.05), prop={'size':'10'})
	#plt.show()
	if non_field:
		fig.savefig("%s/notstored_field.pdf"%(fig_path))
	else:
		fig.savefig("%s/table_field.pdf"%(fig_path))
	plt.close(fig)

def print_clique_stat(prefix):
	validation_r = []
	validation_w = []
	read_to_write = []
	read_to_branch_on_write = []

	clique = []
	depth = []
	cond_list = prefix[:]
	cond_list.append("validation")
	r_cond_list = cond_list[:]
	w_cond_list = cond_list[:]
	read_to_write_cond_list = cond_list[:]
	read_to_branch_on_write_cond_list = cond_list[:]
	depth_cond_list = cond_list[:]

	r_cond_list.append("read")
	w_cond_list.append("write")
	read_to_write_cond_list.append("readToWrite")
	read_to_branch_on_write_cond_list.append("readToBranchOnWrite")
	depth_cond_list.append("depth")

	r = calculateAllActions(r_cond_list)
	validation_r = validation_r + r

	w = calculateAllActions(w_cond_list)
	validation_w = validation_w + w

	rtw = calculateAllActions(read_to_write_cond_list)
	read_to_write = read_to_write + rtw	
 
	rtwob = calculateAllActions(read_to_branch_on_write_cond_list)
	read_to_branch_on_write = read_to_branch_on_write + rtwob

	d = calculateAllActions(depth_cond_list)
	depth = depth + d
	print "depth:"
	print depth

	cond_list = prefix[:]
	cond_list.append("clique")
	r = calculateAllActions(cond_list)
	clique = clique + r

	rtw_ratio = []
	i=0
	for r in read_to_write:
		if validation_r[i] > 0:
			rtw_ratio.append(float(read_to_write[i])/float(validation_r[i]))
		#else:
		#	rtw_ratio.append(1)
		i += 1
	rtb_ratio = []
	i=0
	for r in read_to_branch_on_write:
		if validation_r[i] > 0:
			rtb_ratio.append(float(read_to_branch_on_write[i])/float(validation_r[i]))
		#else:
		#	rtb_ratio.append(1)
		i += 1
	other_ratio = []
	i=0
	for r in read_to_write:
		if validation_r[i] > 0:
			other_ratio.append(float(validation_r[i]-read_to_write[i]-read_to_branch_on_write[i])/float(validation_r[i]))
		#else:
		#	rtb_ratio.append(1)
		i += 1
	print "readToWrite: mean\t%f\tvariance\t%f"%(np.mean(rtw_ratio),np.var(rtw_ratio))
	print "readToBranchOnWrite: mean\t%f\tvariance\t%f"%(np.mean(rtb_ratio),np.var(rtb_ratio))
	print "other: mean\t%f\tvariance\t%f"%(np.mean(other_ratio),np.var(other_ratio))
	#print "Average validation length:\t%f\tRead:\t%f\tWrite:\t%f\tlen=\t%d\tvalidations"%(getAverage(validation_r)+getAverage(validation_w)+1, getAverage(validation_r), getAverage(validation_w)+1, len(validation_r))
	stats_file.write("\t<transaction>\n")
	stats_file.write("\t\t<readToWriteInTxn>%f</readToWriteInTxn>\n"%getAverage(read_to_write))
	stats_file.write("\t\t<readToBranchOnWrite>%f</readToBranchOnWrite>\n"%getAverage(read_to_branch_on_write))
	stats_file.write("\t\t<read>%f</read>\n"%(getAverage(validation_r)-getAverage(read_to_write)-getAverage(read_to_branch_on_write)))
	stats_file.write("\t\t<write>%f</write>\n"%(getAverage(validation_w)+1))
	stats_file.write("\t</transaction>\n")
	stats_file.write("\t<transactionNested>\n")
	if len(depth) > 0:
		for d in range(int(max(depth)+1)):
			cnt = 0
			for dep in depth:
				if int(dep) == d:
					cnt += 1
			stats_file.write("\t\t<nested%dDepth>%d</nested%dDepth>\n"%(d, cnt, d))
	else:
		stats_file.write("\t\t<nested0dDepth>1</nested0Depth>\n")
	#stats_file.write("\t\t<nestedDepth>%f</nestedDepth>\n"%getAverage(depth))
	stats_file.write("\t</transactionNested>\n")
	#print "Average clique size:\t%f\tnumber\t%d"%(getAverage(clique), len(clique)) 

query_keyword = {}
def print_query_string(prefix):
	for root in roots:
		for child in root:
			if child.tag == "queryString":
				for c in child:
					if c.tag not in query_keyword:
						query_keyword[c.tag] = 0
					query_keyword[c.tag] += 1
	stats_file.write("\t<queryString>\n")
	for q,f in query_keyword.items():
		stats_file.write("\t\t<%s>%d</%s>\n"%(q,f,q))
	stats_file.write("\t</queryString>\n")

const_keyword = {}
def print_const_stat(prefix):
	for root in roots:
		for child in root:
			if child.tag == "constStats":
				for c in child:
					if c.tag not in const_keyword:
						const_keyword[c.tag] = 0
					const_keyword[c.tag] += 1
	stats_file.write("\t<constStat>\n")
	for q,f in const_keyword.items():
		stats_file.write("\t\t<%s>%d</%s>\n"%(q,f,q))
	stats_file.write("\t</constStat>\n")



def print_schema_stat(prefix, table_stat_prefix):
	table_refs_total = {}
	table_refs_indirect = {}
	table_list = {}
	assoc_cnt = {}
	tblfield_total = {}
	relation = {}
	for table in tables:
		table_list[table] = {}
		tblfield_total[table] = 0
		table_refs_total[table] = 0
		table_refs_indirect[table] = {}
		for table1 in tables:
			table_refs_indirect[table][table1] = 0

	for table in tables:
		for root in roots:
			for rnode in root:
				if rnode.tag == prefix[0]:
					for child in rnode:
					#child.tag = "User"
						if child.tag == table:
							#count total queries on that table:
							cond_list = table_stat_prefix[:]
							cond_list.append(table)
							cond_list.append("queryTotal")
							table_refs_total[table] = sum(calculateAllActions(cond_list))

							for c in child:
							#c.tag = "Group" or "totalFieldRef"
								if c.tag == "totalFieldRef":
									tblfield_total[table] += float(c.text)
								else:
									if c.tag not in table_list[table]:
										table_list[table][c.tag] = 0
									table_list[table][c.tag] += float(c.text)
									relation["%s->%s"%(table,c.tag)] = c.attrib["relationship"]
									if c.tag in table_refs_indirect:
										table_refs_indirect[c.tag][table] += 1

	fieldref_sum = 0
	#for table in tables:
	#	print "Table %s (total field use %d):"%(table, tblfield_total[table])
	#	fieldref_sum += tblfield_total[table]
	#	for k,v in table_list[table].items():
	#		print "\t%s(%d) [%s]"%(k, v, relation["%s->%s"%(table, k)])
	#		r = relation["%s->%s"%(table, k)]
	#		if r not in assoc_cnt:
	#			assoc_cnt[r] = 0
	#		assoc_cnt[r] += v
	#print "----"
	#print "general:"
	#print "refsum:\t%d"%fieldref_sum
	#for k,v in assoc_cnt.items():
	#	print "%s:\t%d"%(k,v)

	fig = plt.figure()
	ax = fig.add_subplot(111)	
	tmp_cnt = 0
	texts = []
	width = 0.2
	data1 = []
	data2 = []
	table_ref_temp = []	
	for table in tables:
		indirect_count = 0
		indirect_table = 0
		for k,v in table_refs_indirect[table].items():
			if v > 0:
				indirect_count += v
				indirect_table += 1
		if indirect_count > 0:
			data1.append(indirect_count)
			data2.append(table_refs_total[table] - indirect_count)
			tmp_cnt += 1
			texts.append(indirect_table)
			table_ref_temp.append(table)

	ind = np.arange(tmp_cnt)
	rect1 = ax.bar(ind, data1, width, color=tableau_colors[colors[0]])
	rect2 = ax.bar(ind, data2, width, bottom=data1, color=tableau_colors[colors[1]])

	i = 0
	for rect in rect2:
		height = rect.get_height() + rect1[i].get_height()
		ax.text(rect.get_x() + rect.get_width()/2., 1.05*height,'%d' % texts[i], ha='center', va='bottom')
		i += 1
	if len(rect1) > 0:
		ax.set_xticks(ind + width)
		ax.set_xticklabels(table_ref_temp,rotation='vertical')
		ax.set_xlabel("table name")
		ax.set_ylabel("aggregate query number across all actions")
		ax.legend((rect1[0], rect2[0]), ('indirect','direct'),prop={'size':'10'}, loc='upper right')
		fig.savefig("%s/indirect_table_query.pdf"%(fig_path))

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

	#print "path:\t%f\t%f\t%f"%(data["shortestPath"], data["longestPath"], data["instrTotal"])
	stats_file.write("\t<path>\n")
	stats_file.write("\t\t<shortest>%f</shortest>\n"%data["shortestPath"])
	stats_file.write("\t\t<longest>%f</longest>\n"%data["longestPath"])
	stats_file.write("\t\t<instrTotal>%f</instrTotal>\n"%data["instrTotal"])
	stats_file.write("\t</path>\n")

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
	fig.savefig("%s/path.pdf"%(fig_path))



#print_general_stat(general_stats_prefix, general_stats_content, True)
#for table in table_names:
#	pref = table_stats_prefix[:]
#	pref.append(table)
#	if table == "general":
pref = table_stats_prefix[:]
pref.append("general")
print_general_stat(pref, general_stats_content, True, True)
#	else:
#		print_general_stat(pref, table_stats_content, False, False)

print_table_query_stat(pref)
print_fields(nonfield_prefix, field_stats_content, True)
print_fields(field_prefix, field_stats_content)
print_path(prefix3, path_stats_content+path_stats_content2)

print_view_stat(view_stat_prefix)
print_clique_stat(clique_stat_prefix)
print_schema_stat(schema_stat_prefix, table_stats_prefix)

print_query_string("")
print_const_stat("")
print_chain(prefix2, [])

stats_file.write("</%s>"%app_name)

