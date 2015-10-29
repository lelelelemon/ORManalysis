import fnmatch, os, sys

def get_method_name(line):
        if 'def' in line:
                line = line.split()[1]
                if line[len(line)-1] == '\n' or line[len(line)-1] == ' ' or line[len(line)-1] == '\t' or line[len(line)-1] == ':':
                       line = line[:-1] 
        return line

if len(sys.argv) != 4:
	print "Usage: search_ruby_erb.py controller_dir view_dir output"
	exit()

controller_dir = sys.argv[1]
view_dir = sys.argv[2]
output = sys.argv[3]

print controller_dir
print view_dir

fout = open(output, "wb")
for c_root, c_dirnames, c_filenames in os.walk(controller_dir):
	print c_root, c_dirnames, c_filenames
        for c_filename in c_filenames:
                c_filename = os.path.join(c_root, c_filename)
                with open(c_filename, "rb") as c_fin:

                        line = c_fin.readline()
                        while 1:
                                method_body = ""
                                view_body = "\nVIEW: "
                                if not line:
                                        break
                                if "def" in line:
                                        view_name = get_method_name(line)
                                        for v_root, v_dirnames, v_filenames in os.walk(view_dir):
##                                                print v_root, v_dirnames, v_filenames

##                                                print c_filename[len(controller_dir): -14]
##                                                print v_root[len(view_dir):]
                                                if c_filename[len(controller_dir): -14] == v_root[len(view_dir):]:
                                                        for v_filename in v_filenames:
                                                                if v_filename.startswith(view_name) or v_filename.startswith("_"+view_name):
                                                                        v_filename = os.path.join(v_root, v_filename)
                                                                        with open(v_filename, "rb") as v_fin:
                                                                                view_body += v_filename + "\n"
                                                                                for v_line in v_fin:
                                                                                        view_body += v_line
                                        view_body += "\n"
                                        
                                        method_body += line
                                        line = c_fin.readline()
                                        while 1:
                                                if not line:
                                                        fout.write("CONTROLLER: " + c_filename + "\n"  + method_body + view_body + "\n")
                                                        break
                                                
                                                elif not "def" in line:
                                                        method_body += line
                                                else:
                                                        fout.write("CONTROLLER: " + c_filename +"\n"+ method_body  + view_body + "\n")
                                                        break
                                                line = c_fin.readline()
                                else:
                                        line = c_fin.readline()
                                        
                                        
        
        


fout.close()
