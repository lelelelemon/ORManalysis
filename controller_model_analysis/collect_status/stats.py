import numpy as np
import xml.etree.ElementTree as ET
import sys
import glob
import os
import math
import matplotlib.pyplot as plt
import print_general_stats as stats_general
import print_branch_stats as stats_branch
import print_others as stats_other
import print_field_stats as stats_field

TOTAL_COLOR_NUM=22

width = 0.2
roots = []
app_name = sys.argv[1]
app_dir = "../../applications"
switch_file = open("../compute_switch.rb", "r")

stats_file_path = sys.argv[2]
stats_file = open(stats_file_path, 'w')

base_path = "%s/%s/results/"%(app_dir, app_name)
'''
tablename_file = "%s/%s/table_name.txt"%(app_dir, app_name)
tablefield_file = "%s/%s/tablefields.txt"%(app_dir, app_name)
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
'''
roots = []

switches = {}
for line in switch_file:
	chs = line.split("=")
	if len(line) > 0 and '$' in line and len(chs) == 2:
		if "true" in chs[1]:
			switches[chs[0].replace("$","")] = 1
		else:
			switches[chs[0].replace("$","")] = 0

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("stats.xml"):
			fname = os.path.join(subdir, fn)
			print fname
			#TODO: if a file is still being written, ignore it!
			tree = ET.parse(fname)
			roots.append(tree.getroot())

stats_file.write("<stats>\n")

Qtotal = 0
readQtotal = 0
args = {}
args['contents'] = ['queryTotal', 'readTotal', 'writeTotal']
args['prefix'] = ['stat', 'general']
[Qtotal, readQtotal] = stats_general.print_general_stats(roots, stats_file, args)
args['qtotal'] = Qtotal
args['readTotal'] = readQtotal
args['writeTotal'] = Qtotal-readQtotal

args['prefix'] = ['branchOnQueryType']
stats_branch.print_branch_on_query_stats(roots, stats_file, args)

args['prefix'] = ['queryVariable']
stats_other.print_query_overlap(roots, stats_file, args)

args['prefix'] = ['redundantTable']
stats_other.print_redundant_table(roots, stats_file, args)

args['prefix'] = ['fieldOrder', 'f']
stats_field.print_field_order(roots, stats_file, args)

stats_file.write("</stats>\n")


