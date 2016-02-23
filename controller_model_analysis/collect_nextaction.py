import numpy as np
import xml.etree.ElementTree as ET
import sys
import glob
import os
import matplotlib.pyplot as plt
import matplotlib.backends.backend_pdf as pdfp
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

app_name = sys.argv[1]

base_path = "../applications/%s/results"%app_name
fig_path = "../applications/%s/figs/next_actions"%app_name

if os.path.isdir(fig_path) == False:
	os.system("mkdir %s"%fig_path)

#preprocess
for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("next_action.xml"):
			fname = os.path.join(subdir, fn)
			f = open(fname,'r')
			filedata = f.read()
			f.close()
			newdata = filedata.replace("::","")
			newdata = newdata.replace("Admin/","Admin")
			f = open(fname,'w+')
			f.write(newdata)
			f.close()


def find(str, ch):
	for i, ltr in enumerate(str):
		if ltr == ch:
			yield i

def print_single_action(ax, ax_stat, stat, prev_field, next_field, colors, tbl_name):
	overlap = []
	height = 0
	for p in prev_field:
		if p in next_field and p not in overlap:
			overlap.append(p)
			height = height + 1
		elif p not in next_field:
			height = height + 1
	for n in next_field:
		if n not in overlap:
			height = height + 1
	text1 = ""
	text2 = ""
	for p in prev_field:
		text1 += "%s\n"%p
	for n in next_field:
		text2 += "%s\n"%n

	ind = np.arange(1)
	width = 0.2
	yind = range(0, height+1)
	ax.set_ylim(0, height+3)
	rect1 = ax.bar(ind, [len(prev_field)], width, color=tableau_colors[colors[0]])
	rect2 = ax.bar(ind+width, [len(next_field)], width, bottom=[len(prev_field)-len(overlap)], color=tableau_colors[colors[0]])
	#ax.text(rect1[0].get_x()+rect1[0].get_width()*0.5, 1.05*rect1[0].get_height(), '%s'%text1, ha='center', va='bottom', size=6)
	#ax.text(rect2[0].get_x()+rect2[0].get_width()*0.5, 1.05*rect2[0].get_height(), '%s'%text2, ha='center', va='bottom', size=6)
	ax.set_xticklabels((''))
	ax.set_yticks(yind)
	ax.legend((rect1[0], rect2[0]), ('prev_fields', 'next_fields'), loc='upper left', prop={'size':'8'})
	ax.set_title(table_name, fontsize=8)

	ind = np.arange(1)
	max_h = max(stat["prevRead"]+stat["prevWrite"], stat["nextRead"])
	yind = range(0, max_h+1, 4)
	ax_stat.set_ylim(0, max_h+3)
	rect3 = ax_stat.bar(ind, [stat["prevRead"]], width, color=tableau_colors[colors[0]])
	rect4 = ax_stat.bar(ind, [stat["prevWrite"]], width, bottom=[stat["prevRead"]], color=tableau_colors[colors[1]])
	rect5 = ax_stat.bar(ind+width, [stat["nextRead"]], width, color=tableau_colors[colors[0]])
	ax_stat.set_xticklabels((''))
	ax_stat.set_yticks(yind)
	ax_stat.legend((rect3[0], rect4[0], rect5[0]), ('prevReadQ', 'prevWriteQ', 'nextReadQ'), prop={'size':'8'})

tables = []
#different color for each table
table_color_map = {}
color_index = 0

overlap_table_name = {}
overlap_table_count = []

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("next_action.xml"):
			save = True
			fname = os.path.join(subdir, fn)
			temp_l = list(find(fname, "/"))
			cur_action_name = fname[temp_l[-2]+1:temp_l[-1]]
			print fname
			tree = ET.parse(fname)
			root = tree.getroot()
			#root.tag = NEXTACTION
			num_actions = len(root)
			if num_actions == 0:
				continue

			with pdfp.PdfPages('%s/%s.pdf'%(fig_path, cur_action_name)) as pdf:
				print "num_actions = %d"%num_actions
				for c in (root):
					#c.tag = CommentsController_index
					#initiate a figure here
					fig = plt.figure()
					num_tables = len(c)
					overlap_table_count.append(num_tables)
					print "num_tables = %d"%num_tables
					i = 0
					for child in c:
					#child.tag = User
						if child.tag != "string" and child.tag != "integer" and child.tag != "boolean":
							#assign colors
							table_name = child.tag
							colors = []
							if table_name not in table_color_map:
								table_color_map[table_name] = color_index
								color_index += 2
								color_index = color_index % TOTAL_COLOR_NUM
								overlap_table_name[table_name] = 0
							colors.append(table_color_map[table_name])
							colors.append(table_color_map[table_name]+1)
							overlap_table_name[table_name] += 1

							ax = fig.add_subplot(num_tables, 2, i*2)
							ax_stat = fig.add_subplot(num_tables, 2, i*2+1)
							prev_field = []
							next_field = []
							stat = {}
							for s in child:
								if s.tag == "stat":
									for sc in s:
										stat[sc.tag] = int(sc.text) 
								elif s.tag == "prevField":
									prev_field.append(s.text)
								elif s.tag == "nextField":
									next_field.append(s.text)
							#print prev_field
							#print next_field
							#print stat
							print_single_action(ax, ax_stat, stat, prev_field, next_field, colors, table_name)
							i = i + 1
					#plt.show()
					plt.suptitle('%s'%c.tag)
					pdf.savefig(fig)
				#exit()	

def getAverage(l):
	if len(l)==0:
		return 0.0
	else:
		return float(sum(l)) / float(len(l))

for k, v in overlap_table_name.items():
	print "%s, %d outof %d"%(k, v, len(overlap_table_count))

print "Average table overlap for each next_action: %f"%getAverage(overlap_table_count)