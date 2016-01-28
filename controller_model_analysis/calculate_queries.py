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

base_path = "../applications/%s/results/"%sys.argv[1]
txn = []
lcnt = []
total = []
total_min = 100
total_max = 0
stats = {}
stats_cnt = {}
tables = {}
tbl_fields = {}
table_queries = {}
#key: tablename.field
tbl_fields_type = {}
tbl_var = {}

tbl_read_record = {}
tbl_read_record_cnt = {}
tbl_write_record = {}
tbl_write_record_cnt = {}
tbl_write_record_fields = {}

tablename_file = "../applications/%s/table_name.txt"%sys.argv[1]
tablename_fp = open(tablename_file)
for line in tablename_fp:
	line = line.replace("\n","")
	tables[line] = {}
	tables[line]["SELECT"] = 0
	tables[line]["DELETE"] = 0
	tables[line]["UPDATE"] = 0
	tables[line]["INSERT"] = 0
	tables[line]["TXN"] = 0
	tables[line]["TRANSACTION"] = 0
	tables[line]["JOIN"] = 0
	tables[line]["GROUP"] = 0
	tbl_fields[line] = {}
	table_queries[line] = []

tables["UNKNOWN"] = {}
tables["UNKNOWN"]["SELECT"] = 0
tables["UNKNOWN"]["TRANSACTION"] = 0
tables["UNKNOWN"]["DELETE"] = 0
tables["UNKNOWN"]["UPDATE"] = 0
tables["UNKNOWN"]["INSERT"] = 0
tables["UNKNOWN"]["TXN"] = 0
tables["UNKNOWN"]["JOIN"] = 0
tables["UNKNOWN"]["GROUP"] = 0
table_queries["UNKNOWN"] = []

chain_data = []
for i in range(5):
	chain_data.append([])
Input = []
nonfield = {}
assignfield = {}
nf = {}

for subdir, folders, files in os.walk(base_path):
	for fn in files:
		if fn.endswith("trace.temp"):
			
			fp = open(os.path.join(subdir, fn), "r")
			#print "filename: %s"%(os.path.join(subdir, fn))
			line_cnt = 0
			for line in fp:
				if "transaction begin" in line:
					txn.append(line_cnt)
				if "transaction end" in line:
					temp_l = txn.pop()
					#print "temp_l = %d"%(line_cnt-temp_l)
					lcnt.append(line_cnt-temp_l)
				if "QUERY" in line:
					line_cnt = line_cnt + 1
		if fn.endswith("sketch_stats.txt"):
			fp = open(os.path.join(subdir, fn), "r")
			for line in fp:
				line = line.replace("\n","")
				chs = line.split(" ")
				if chs[0] == "chain:":
					for i in range(5):
						chain_data[i].append(int(chs[i+1], 10))
				elif chs[0] == "Input:":
					Input.append(int(chs[1], 10))
				elif chs[0] == "Nonfield:":
					print line
					if chs[1] not in nonfield:
						nonfield[chs[1]] = []
						nonfield[chs[1]].append([])
						nonfield[chs[1]].append([])
					nonfield[chs[1]][0].append(int(chs[2], 10))
					nonfield[chs[1]][1].append(int(chs[3], 10))
				elif chs[0] == "FieldAssign:":
					print line
					if chs[3] not in assignfield:
						assignfield[chs[1]] = []
						assignfield[chs[1]].append([])
						assignfield[chs[1]].append([])
					assignfield[chs[1]][0].append(int(chs[2], 10))
					assignfield[chs[1]][1].append(int(chs[4], 10))

					
		elif fn.endswith(".txt"):
			fp = open(os.path.join(subdir, fn), "r")
			#print "filename: %s"%(os.path.join(subdir, fn))
			for line in fp:
				line = line.replace("\n","")
				chs = line.split(" ")
				if "query in total" in line:
					t = int(chs[-1], 10)
					if t == 0:
						print "ZERO: %s"%subdir
					total.append(int(chs[-1], 10))
					if t < total_min:
						total_min = t
					if t > total_max:
						total_max = t
				elif "STATS" in line:
					vmap = line.split("  ")
					if ": " in line:
						vmap = line.split(": ")
					if vmap[0] in stats:
						stats[vmap[0]].append(int(chs[-1], 10))
					else:
						stats[vmap[0]] = []
						stats[vmap[0]].append(int(chs[-1], 10))
				#elif "+FIELD+" in line:
					#info = chs[2].split(".")
					#table = info[0]
					#field = info[1]
					#var_name = chs[1]
					#if var_name in tbl_var:
					#	tbl_var[var_name] = tbl_var[var_name] + 1
					#else:
					#	tbl_var[var_name] = 1
					#f_type = chs[3].replace(")","").replace("(","")
					#if tbl_fields.has_key(table):
					#	if tbl_fields[table].has_key(field) == False:
					#		tbl_fields[table][field] = 1
					#		tbl_fields_type[chs[1]] = f_type
					#	else:
					#		tbl_fields[table][field] = tbl_fields[table][field] + 1
				elif "TBLREADRECORD:" in line:
					table = chs[1]
					data_list = chs[2].replace("[","").replace("]","").split(",")
					if table not in tbl_read_record:
						tbl_read_record[table] = []
						for i in range(4):
							tbl_read_record[table].append(0)
							tbl_read_record_cnt[table] = 0
					tbl_read_record_cnt[table] = tbl_read_record_cnt[table] + 1
					for i in range(4):
						tbl_read_record[table][i] += int(data_list[i], 10)
				elif "TBLWRITERECORD:" in line:
					table = chs[1]
					data_list = chs[2].replace("[","").replace("]","").split(",")
					if table not in tbl_write_record:
						tbl_write_record[table] = []
						tbl_write_record_fields[table] = {}
						for i in range(3):
							tbl_write_record[table].append(0)
							tbl_write_record_cnt[table] = 0
					tbl_write_record_cnt[table] = tbl_write_record_cnt[table] + 1
					for i in range(3):
						tbl_write_record[table][i] += int(data_list[i], 10)
					fields = chs[-1].replace("[","").replace("]","").split(",")
					for f in fields:
						if f in tbl_write_record_fields[table]:
							tbl_write_record_fields[table][f] += 1
						else:
							tbl_write_record_fields[table][f] = 1
				elif len(line) > 0:
					if "<" in line and ">" in line:
						if "]" in chs[-1]:
							print line
						for c in chs:
							if "<" in c and ">" in c:
								info = c.split(",")
								if len(info) == 2:
									table = info[0].replace("<","")
									op = info[1].replace(">","")
									if len(table) == 0:
										table = "UNKNOWN"
									#if tables.has_key(table):
									#	tables[table][op] = tables[table][op] + 1
									#	query = line[0:line.index("<")-1]
									#	if query not in table_queries[table]:
									#		table_queries[table].append(query)
						

plt.figure(1)  
plt.subplot(321)
plt.plot(chain_data[1], chain_data[2], 'ro')
plt.xlabel("# of out nodes")
plt.ylabel("# of in nodes")
plt.subplot(322)
plt.plot(chain_data[2], chain_data[3], 'ro')
plt.xlabel("# of out sink nodes")
plt.ylabel("# of in source nodes")
plt.subplot(323)
plt.hist(chain_data[0], 10)
plt.xlabel("Histogram of def-use chain length (only queries)")
plt.subplot(324)
plt.hist(Input, 20, color='green')
plt.xlabel("Importance of input: #of queries each input affected")
plt.subplot(325)

data_nonfield = []
data_nonfield.append([])
data_nonfield.append([])
for k,v in nonfield.items():
	data_nonfield[0].append(sum(v[0]))
	data_nonfield[1].append(sum(v[1]) / float(len(v[1])))
plt.plot(data_nonfield[1], data_nonfield[0], 'b*')
plt.xlabel("Average #of instructions (distance) from source")
plt.ylabel("#of appearance")

plt.subplot(326)
data_assignfield = []
data_assignfield.append([])
data_assignfield.append([])
for k,v in assignfield.items():
	data_assignfield[0].append(sum(v[0]))
	data_assignfield[1].append(sum(v[1]) / float(len(v[1])))
#plt.plot(data_assignfield[1], data_assignfield[0], 'b*')
plt.scatter(data_assignfield[1], data_assignfield[0], color=tableau_colors)
plt.xlabel("Average #of instructions (distance) from source")
plt.ylabel("#of appearance")

plt.tight_layout(pad=1.08, h_pad=None, w_pad=None, rect=None)
plt.show()

#print "Average txn length: %f"%(float(sum(lcnt)) / float(len(lcnt)))
print "Controller functions: %d"%len(total)

print "Average query in total: %f"%(float(sum(total)) / float(len(total)))
print "\tmin: %d, max: %d"%(total_min, total_max)

total_queries = 0
for k,v in stats.items():
	if "read" not in k and "write" not in k:
		#print "Average %s: %f"%(k,float(sum(v))/float(len(v)))
		if "query total on single path" in k:
			print "Total %s: %d"%(k, float(sum(v))/float(len(v)))
		elif "query in total" in k:
			print "Total %s: %d"%(k, sum(v))

print ""
read_total = 0
for k,v in stats.items():
	if "read" in k:
		#print "Average %s: %f"%(k,float(sum(v))/float(len(v)))
		print "Total %s: %d"%(k, sum(v))
	if "read queries" in k:
		read_total = sum(v)


print ""
for k,v in stats.items():
	if "write" in k and "read" not in k:
		if "write queries" in k:
			print "Total %s: %d"%(k, sum(total)-read_total)
		else:
		#print "Average %s: %f"%(k,float(sum(v))/float(len(v)))
			print "Total %s: %d"%(k, sum(v))

#for k,v in tables.items():
#	print "Table %s:"%k
#	if k in tbl_read_record:
#		print "\tread %d times"%tbl_read_record_cnt[k]
#		print "\tstats: ",
#		for s in tbl_read_record[k]:
#			print "%d, "%s,
#		print ""
#	if k in tbl_write_record:
#		print "\twrite %d times"%tbl_write_record_cnt[k]
#		print "\tstats: ",
#		for s in tbl_write_record[k]:
#			print "%d, "%s,
#		print ""
		#print "\tfield set: ",
		#for s,m in tbl_write_record_fields[k].items():
		#	if len(s) > 0:
		#		print "%s(%d), "%(s, m),
		#print ""


#for k,v in tables.items():
#	print "===================="
#	print "Table %s:"%k
#	for k1, v1 in v.items():
#		if v1 > 0:
#			print "\t%s: %d times"%(k1, v1)
#	if tbl_fields.has_key(k):
#		for k1, v1 in tbl_fields[k].items():
#			if v1 > 0:
#				f = "%s.%s"%(k, k1)
#				print "\t\tfield %s\t[type: %s] accessed %d times"%(k1, tbl_fields_type[f], v1)
#	print "Have %d types of queries:"%(len(table_queries[k]))
#	for q in table_queries[k]:
#		print "\t%s"%q
#	print ""

