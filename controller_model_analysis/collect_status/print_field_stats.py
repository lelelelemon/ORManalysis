import util

def print_field_order(roots, stats_file, args):
	data = {}
	cond_list = args['prefix'][:]
	r = util.collectByAttribute(roots, cond_list, "fieldn", ["sz"])
	stats_file.write("\t<fieldOrderByName>\n")
	for k,v in r.items():
		#k: main_attrib
		#v: [text, [other_attribs]]
		#count distinct of text
		orders = []
		for v1 in v:
			if v1[0] not in orders:
				orders.append(v1[0])
		stas_file.write("\t\t<%s>%d</%s>\n"%(k, len(orders), k))
	stats_file.write("\t<fieldOrderByName>\n")

	
	#r = collectByAttribute(roots, cond_list, "sz", ["fieldn"])
	#stats_file.write("\t<fieldOrderBySize>\n")
