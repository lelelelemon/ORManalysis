import util

def print_query_overlap(roots, stats_file, args):
	cond_list = args['prefix'][:]
	r = util.calculateCount(roots, cond_list)	
	d	= []
	for k,v in r.items():
		d.append(int(k, 10))
	d.sort()
	stats_file.write("\t<queryOverlap>\n")
	for i in d:
		stats_file.write("\t\t<variableHas%sQs>%d</variableHas%dQs>\n"%(i, r[str(i)], i))
	stats_file.write("\t</queryOverlap>\n")


def print_redundant_table(roots, stats_file, args):
	cond_list = args['prefix'][:]
	tables = util.collectAllTags(roots, cond_list)	
	data = {}
	print tables
	for t in tables:
		cond_list = args['prefix'][:]
		cond_list.append(t)
		r = util.calculateAllActions(roots, cond_list)
		data[t] = len(r)

	stats_file.write("\t<redundantTable>\n")
	for k,v in data.items():
		stats_file.write("\t\t<%s>%d</%s>\n"%(k,v,k))
	stats_file.write("\t<redundantTable>\n")

