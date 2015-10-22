import xml.etree.ElementTree as ET
import os
#import pydot

models = {}
views = {}
controllers = {}

global_node_labels = []
for i in range(128):
	letter1 = chr(65+i/26)
	letter2 = chr(65+i%26)
	label = letter1+letter2
	global_node_labels.append(label)

f = open("temp.diag", "w")
global_node_cnt = 0

class baseRoot:
	queries = [] #type: class Query
	methods = {}
	var_list = []
	class_name = ""
	def __init__(self):
		self.queries = []
		self.methods = {}
	def __init__(self, cnode, class_name=""):
		self.queries = []
		self.methods = {}
		self.parseRoot(cnode)
		self.class_name = class_name
	def appendMethod(self, mnode):
		m = Method(mnode.attrib["name"])
		m.parseMethod(mnode)
		self.methods[m.name] = m
	def parseRoot(self, rootn):
		for child in rootn:
			if child.tag == "method":
				self.appendMethod(child)	
	def selfPrint(self):
		for key in self.methods:
			print "***** key = %s *****"%key

class CallGraphNode:
	level = 0
	node_type = ""
	caller = "" # Model/View/Controller instance
	inputs = {} #This should be a hash set, but I am not familiar with that, so I simply used dict.
	outputs = {} #Should be hash set. key = value
	children = []
	label = ""
	def __init__(self, caller):
		self.caller = caller
		self.level = 0
		self.inputs = {}
		self.outputs = {}
		self.children = []
		global global_node_cnt
		self.label = global_node_labels[global_node_cnt]
		global_node_cnt = global_node_cnt + 1
	def addChild(self, child):
		global f
		self.children.append(child)
		edge_label = ""
		for i in child.inputs:
			edge_label = edge_label + child.inputs[i] + ", "
		reverse_edge_label = ""
		for o in child.outputs:
			reverse_edge_label = reverse_edge_label + child.outputs[o] + ", "
		#f.write("\t"+self.label+" -> "+child.label+";\n")
		f.write("\t"+self.label+" -> "+child.label+" [label = \""+edge_label+"\", fontsize = 10];\n");
		f.write("\t"+child.label+" -> "+self.label+" [label = \""+reverse_edge_label+"\", fontsize = 10];\n");
	def mergeInputs(self, inputs):
		for i in inputs:
			self.inputs[i] = i
	def mergeOutputs(self, outputs):
		for o in outputs:
			self.outputs[o] = o
	def setValues(self, node_type, level, inputs, outputs):
		global f
		self.node_type = node_type
		self.level = level
		self.mergeInputs(inputs)
		self.mergeOutputs(outputs)
		if node_type.__class__.__name__ == "Query":
			f.write("\t"+self.label+" [label = \""+node_type.operation+"_"+node_type.table+"\", color = blue];\n")
		elif node_type.__class__.__name__ == "Action":	
			f.write("\t"+self.label+" [label = \"Action_"+node_type.behavior+"\", color = pink];\n")
		elif node_type.__class__.__name__ == "Call":
			f.write("\t"+self.label+" [label = \""+node_type.class_name+"."+node_type.class_type+"."+node_type.function_name+"\"];\n")
		else:
			f.write("unrecognized")

class Query:
	text = "SELECT"
	table = "table"
	operation = ""
	field = []
	params = []
	returnv = []
#	def __init__(self, text):
#		self.text = text
	def __init__(self, qnode):
		self.field = []
		self.params = []
		self.returnv = []
		self.parseQuery(qnode)
	def appendTable(self, table):
		self.table = table
	def appendField(self, field):
		self.field = field
	def appendParam(self, params):
		self.params = params
	def appendReturnv(self, returnv):
		self.returnv = returnv
	def parseQuery(self, qnode):
		assert(qnode.find("text") != None)
		self.text = qnode.find("text").text
		if qnode.find("field")!=None:
			for single_field in qnode.iter("field"):
				if single_field.text != "ALL":
					self.field.append(single_field.text)
		if qnode.find("table")!=None:
			self.table = qnode.find("table").text
		if qnode.find("input")!=None:
			for single_param in qnode.iter("input"):
				self.params.append(single_param.text)
		if qnode.find("param")!=None:
			for single_param in qnode.iter("param"):
				self.params.append(single_param.text)
		if qnode.find("return")!=None:
			for single_return in qnode.iter("return"):
				self.returnv.append(single_return.text)
		if qnode.find("operation")!=None:
			self.operation = qnode.find("operation").text
	def traceExecution(self, inputs, gnode):
		new_node = CallGraphNode(gnode.caller)
		new_node.setValues(self, gnode.level+1, self.params, self.returnv)
		gnode.addChild(new_node)
		return self.returnv
	def selfPrint(self):
		print "Query:"
		print "\ttext = %s"%self.text
		print "\ttable = %s"%self.table
	
class Call:
	class_name = "class_name"
	class_type = "model"
	function_name = "function"
	feeds = []
#	def __init__(self, attrib):
#		if attrib.find("class") != None:
#			class_name = attrib["class"]
#		if attrib.find("class_type") != None:
#			class_type = attrib["class_type"]
#		if attrib.find("function_name") != None:
#			function_name = attrib["function_name"]
	def __init__(self, cnode):
		self.feeds = []
		self.parseCall(cnode)
	def parseCall(self, cnode):
		self.class_name = cnode.attrib["class"]
		self.class_type = cnode.attrib["class_type"]
		self.function_name = cnode.attrib["function_name"]
		if cnode.find("feed") != None:
			for single_feed in cnode.iter("feed"):
				self.feeds.append(single_feed.text)
	def traceExecution(self, inputs, gnode):
		returnv = []
		caller = gnode.caller 	
		new_node = CallGraphNode(gnode.caller)
		new_node.setValues(self, gnode.level+1, self.feeds, [])
		if self.class_type == "model":
			print "%s_model methods: %s"%(self.class_name, self.function_name)
			m = models[self.class_name].methods[self.function_name]	
			caller = models[self.class_name]
			returnv = m.traceExecution(self.feeds, new_node)
		elif self.class_type == "controller":
			print "%s_controller methods: %s"%(self.class_name, self.function_name)
			m = controllers[self.class_name].methods[self.function_name]
			caller = controllers[self.class_name]
			returnv = m.traceExecution(self.feeds, new_node)
		elif self.class_type == "view":
			print "%s_view methods: %s"%(self.class_name, self.function_name)
			m = views[self.class_name].methods[self.function_name]
			caller = views[self.class_name]
			returnv = m.traceExecution(self.feeds, new_node)
		else:
			print "Unrecognized call"
		new_node.caller = caller
		new_node.mergeOutputs(returnv)
		gnode.addChild(new_node)
		return returnv
	def selfPrint(self):
		print "Call"
		print "\t class = %s, type = %s, function_name = %s"%(self.class_name, self.class_type, self.function_name)
		print "\t feeds: ",
		for item in self.feeds:
			print item,
		print ""

class Action:
	behavior = "Nothing"
	output = []
#	def __init__(self, behavior):
#		behavior = self.behavior
	def __init__(self, anode):
		self.behavior = anode.find("description").text
		self.output = []
		if anode.find("return") != None:
			for single_output in anode.iter("return"):
				self.output.append(single_output.text)
	def traceExecution(self, inputs, gnode):
		new_node = CallGraphNode(gnode.caller)
		new_node.setValues(self, gnode.level+1, [], self.output)
		gnode.addChild(new_node)
		return self.output
	def selfPrint(self):
		print "Action"
		print "\t%s"%self.behavior

class Method:
	name = "name"
	property_name = ""
	attributes = {}
	inputs = []
	returns = []
	variables = {}
	action_list = [] #actions include action, query, call
	def __init__(self, name):
		self.name = name
		self.action_list = []
		self.inputs = []
		self.returns = []
		self.variables = {}
#	def __init__(self, mnode):
#		self.parseMethod(mnode)
	def parseMethod(self, mnode):
		if mnode.attrib.get("property") != None:
			property_name = mnode.attrib["property"]
		self.attributes = mnode.attrib
		for child in mnode:
			if child.tag == "input":
				self.inputs.append(child.text)
			elif child.tag == "return":
				self.returns.append(child.text)
			elif child.tag == "query":
				self.action_list.append(Query(child))
			elif child.tag == "call":
				self.action_list.append(Call(child))
			elif child.tag == "action":
				self.action_list.append(Action(child))
			else:
				print "unrecognized tag: %s"%child.tag
	def traceExecution(self, inputs, gnode):
		active_params = []
		for action in self.action_list:
		#	if action.__class__.__name__ == "Query":
		#		print "* * * DB_QUERY: * * *"
		#	elif action.__class__.__name__ == "Call":
		#		print "Call"
		#	elif action.__class__.__name__ == "Action":
		#		print "Action"
		#	else:
		#		print "Unrecognized action!"
			active_params = active_params + action.traceExecution(inputs, gnode)
		for a in active_params:
			self.variables[a] = a
		return self.returns
	def selfPrint(self):
		print "Method"
		print "\tname = %s, property = %s"%(self.name, self.property_name)
		print "\tinputs: ",
		for single_input in self.inputs:
			print single_input,
		print ""
		for action in self.action_list:
			action.selfPrint()


class Model(baseRoot):
	name = "Model"

class Controller(baseRoot):
	name = "Controller"

class View(baseRoot):
	name = "View"
	def traceUserAction(self, gnode):
		for m in self.methods:
			global f
			print self.methods[m].name
			if "user_action" in self.methods[m].attributes.keys() and self.methods[m].attributes["user_action"] == "true":
				fname="%s_%s.diag"%(self.class_name, self.methods[m].name)				
				f = open(fname, "w")
				f.write("blockdiag {\n")
				f.write("\tnode_width = 200;\n\tnode_height=100;\n")
				f.write("\tspan_width = 240;\n\tspan_height=120;\n")
				f.write("\tdefault_fontsize = 20;\n")
				f.write("\t"+gnode.label+" [label = \""+self.class_name+"_view\"];\n")
				returnv = self.methods[m].traceExecution([], gnode)
				f.write("}\n")
	
def printBlank(n):
	for i in range(n):
		print " # ",
def printDict(the_dict):
	for i in the_dict:
		print i,
def printGraph(node):
	#pre-order traversal
	printBlank(node.level)
	print node.caller.__class__.__name__,
	if node.node_type.__class__.__name__ == "Query":
		print node.node_type.text
	elif node.node_type.__class__.__name__ == "Action":
		print node.node_type.behavior
	elif node.node_type.__class__.__name__ == "Call":
		print node.node_type.function_name
	else:
		print "Type unknonw: %s"%node.node_type.__class__.__name__
	printBlank(node.level)
	print "  -- input: ",
	printDict(node.inputs)
	print ""
	printBlank(node.level)
	print "  -- output: ",
	printDict(node.outputs)
	print ""
	for child in node.children:
		printGraph(child)

rootdir = "./"
for subdir, dirs, files in os.walk(rootdir):
	for file in files:
		filepath = subdir + os.sep + file
		if filepath.endswith(".xml"):
			filename = filepath[3:len(filepath)]
			print filename
			if "model" in filename:
				model_name = filename[0:filename.find("model")-1]
				tree = ET.parse(filepath)
				root = tree.getroot()
				m = Model(root, model_name)
				models[model_name] = m
			elif "controller" in filename:
				controller_name = filename[0:filename.find("controller")-1]
				tree = ET.parse(filepath)
				root = tree.getroot()
				c = Controller(root, controller_name)
				controllers[controller_name] = c
			elif "view" in filename:
				view_name = filename[0:filename.find("view")-1]
				print "view_name=%s"%view_name
				tree = ET.parse(filepath)
				root = tree.getroot()
				v = View(root, view_name)
				views[view_name] = v
				#v.selfPrint()
			else:
				print "Unrecognized xml file"

## print all view methods
#for v in views:
#	root = CallGraphNode(views[v])
#	global f
#	views[v].traceUserAction(root)
#	printGraph(root)	

## only print methods within specific view (single file)
view_name='message'
root = CallGraphNode(views[view_name])
views[view_name].traceUserAction(root)
#printGraph(root)

