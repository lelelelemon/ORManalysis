import os

app_dir="../applications/lobsters/"
out_dir="../applications/lobsters/print_all"
in_file = open("%s/controllers.txt"%out_dir, "r")

for line in in_file:
	line = line.replace('\n','')
	out_f_name = "%s/%s.log"%(out_dir, line)
	#print "ruby parsing.rb -d %s --print %s &> %s"%(app_dir, line, out_f_name)
	os.system("ruby parsing.rb -d %s --print %s >> %s"%(app_dir, line, out_f_name))
