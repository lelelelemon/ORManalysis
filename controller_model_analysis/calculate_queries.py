import sys
import glob
import os
import matplotlib.pyplot as plt

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
nonfield = []
nonfield.append([])
nonfield.append([])
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
					nonfield[0].append(int(chs[2], 10))
					nonfield[1].append(int(chs[3], 10))
					
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
									if tables.has_key(table):
										tables[table][op] = tables[table][op] + 1
										query = line[0:line.index("<")-1]
										if query not in table_queries[table]:
											table_queries[table].append(query)
						

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
plt.plot(nonfield[1], nonfield[0], 'b*')
plt.xlabel("#of instructions (distance) from source")
plt.show()

#print "Average txn length: %f"%(float(sum(lcnt)) / float(len(lcnt)))
print "Controller functions: %d"%len(total)

print "Average query in total: %f"%(float(sum(total)) / float(len(total)))
print "\tmin: %d, max: %d"%(total_min, total_max)

for k,v in stats.items():
	if "read" not in k and "write" not in k:
		#print "Average %s: %f"%(k,float(sum(v))/float(len(v)))
		print "Total %s: %d"%(k, sum(v))

print ""
for k,v in stats.items():
	if "read" in k:
		#print "Average %s: %f"%(k,float(sum(v))/float(len(v)))
		print "Total %s: %d"%(k, sum(v))


print ""
for k,v in stats.items():
	if "write" in k and "read" not in k:
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

