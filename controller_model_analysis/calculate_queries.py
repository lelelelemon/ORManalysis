import sys
import glob
import os

base_path = "../applications/%s/results/"%sys.argv[1]
txn = []
lcnt = []
total = []
view = []
reads = []
writes = []
tables = {}
tbl_fields = {}
#key: tablename.field
tbl_fields_type = {}

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

tables["UNKNOWN"] = {}
tables["UNKNOWN"]["SELECT"] = 0
tables["UNKNOWN"]["TRANSACTION"] = 0
tables["UNKNOWN"]["DELETE"] = 0
tables["UNKNOWN"]["UPDATE"] = 0
tables["UNKNOWN"]["INSERT"] = 0
tables["UNKNOWN"]["TXN"] = 0
tables["UNKNOWN"]["JOIN"] = 0
tables["UNKNOWN"]["GROUP"] = 0

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
		if fn.endswith(".txt"):
			fp = open(os.path.join(subdir, fn), "r")
			#print "filename: %s"%(os.path.join(subdir, fn))
			for line in fp:
				line = line.replace("\n","")
				chs = line.split(" ")
				if "query in total:" in line:
					total.append(int(chs[-1], 10))
				elif "query in view:" in line:
					view.append(int(chs[-1], 10))
				elif "read queries:" in line:
					reads.append(int(chs[-1], 10))
				elif "write queries:" in line:
					writes.append(int(chs[-1], 10))
				elif "+FIELD+" in line:
					info = chs[1].split(".")
					table = info[0]
					field = info[1]
					f_type = chs[2].replace(")","").replace("(","")
					if tbl_fields.has_key(table):
						if tbl_fields[table].has_key(field) == False:
							tbl_fields[table][field] = 1
							tbl_fields_type[chs[1]] = f_type
						else:
							tbl_fields[table][field] = tbl_fields[table][field] + 1
				elif len(line) > 0:
					for c in chs:
						if "<" in c and ">" in c:
							info = c.split(",")
							table = info[0].replace("<","")
							op = info[1].replace(">","")
							if len(table) == 0:
								table = "UNKNOWN"
							if tables.has_key(table):
								tables[table][op] = tables[table][op] + 1
						
for k,v in tables.items():
	print "Table %s:"%k
	for k1, v1 in v.items():
		if v1 > 0:
			print "\t%s: %d times"%(k1, v1)
	if tbl_fields.has_key(k):
		for k1, v1 in tbl_fields[k].items():
			if v1 > 0:
				f = "%s.%s"%(k, k1)
				print "\t\tfield %s (type: %s) accessed %d times"%(k1, tbl_fields_type[f], v1)

print "Average txn length: %f"%(float(sum(lcnt)) / float(len(lcnt)))

print "Average query in total: %f"%(float(sum(total)) / float(len(total)))

print "Average query in view: %f"%(float(sum(view)) / float(len(view)))

print "Average read queries: %f"%(float(sum(reads)) / float(len(view)))

print "Avery write queries: %f"%(float(sum(writes)) / float(len(view)))

print "Controller functions: %d"%len(total) 
