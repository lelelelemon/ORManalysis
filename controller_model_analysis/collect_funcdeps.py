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

#preprocess....
for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("func_dep.xml"):
			fname = os.path.join(subdir, fn)
			f = open(fname,'r')
			filedata = f.read()
			f.close()
			newdata = filedata.replace("userInput=0","userInput=\"0\"")
			newdata = newdata.replace("userInput=1","userInput=\"1\"")
			f = open(fname, "w+")
			f.write(newdata)
			f.close()


def find(str, ch):
	for i, ltr in enumerate(str):
		if ltr == ch:
			yield i

class FuncDepNode:
	def __init__(self):
		self.dep_fields = []
		self.dep_tables = []
		self.actions = []
	def getFields(self):
		return self.dep_fields
	def getTables(self):
		return self.dep_tables
	def getActions(self):
		return self.actions
	def addAction(self, act):
		if act not in self.actions:
			self.actions.append(act)
	def addField(self, field):
		if field not in self.dep_fields:
			self.dep_fields.append(field)
	def addTable(self, table):
		if table not in self.dep_tables:
			self.dep_tables.append(table)
	def compare(self, node):
		if len(self.dep_fields) != len(node.dep_fields) or len(self.dep_tables) != len(node.dep_tables):
			return False
		for i in self.dep_fields:
			if i not in node.dep_fields:
				return False
		for i in self.dep_tables:
			if i not in node.dep_tables:
				return False
		return True

reject_list = []
#key: field name; value: list
#									value: [node]
accept_list = {}

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("func_dep.xml"):
			fname = os.path.join(subdir, fn)
			temp_l = list(find(fname, "/"))
			cur_action_name = fname[temp_l[-2]+1:temp_l[-1]]
			print fname
			tree = ET.parse(fname)
			root = tree.getroot()
			for c in root: #c.tag = assignedField
				field_name = c.attrib["name"]
				if c.attrib["userInput"]=="1":
					reject_list.append(field_name)
					if field_name in accept_list:
						accept_list.pop(field_name, None)
				elif len(c) > 0:
					temp_node = FuncDepNode()
					temp_node.addAction(cur_action_name)
					for child in c:
						if child.tag == "field":
							temp_node.addField(child.text)
						elif child.tag == "table":
							temp_node.addTable(child.text)
					if field_name not in accept_list:
						accept_list[field_name] = []
						accept_list[field_name].append(temp_node)
					else:
						handled = False
						for p in accept_list[field_name]:
							if p.compare(temp_node) == True:
								p.addAction(cur_action_name)
								handled = True
						if handled == False:
							accept_list[field_name].append(temp_node)
			

for field,v in accept_list.items():		
	i = 0
	print "%s = {"%field
	for node in v:
		i += 1
		print "\tif action == ",
		for action in node.getActions():
			print "%s or "%action,
		print "1"
		if len(node.getFields())>0:
			print "\t\t%s = f_field%d("%(field, i),
			for field2 in node.getFields():
				print "%s, "%field2,
			print "1)"
		if len(node.getTables())>0:
			print "\t\t%s = f_table%d("%(field, i),
			for table2 in node.getTables():
				print "%s, "%table2,
			print "1)"
	print "}"
	print ""
					
