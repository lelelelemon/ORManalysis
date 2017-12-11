#!/usr/bin
import sys
import os
def generate_dataflow(app):
    app = app.replace("/", "")
    if not os.path.isdir(app + "/dataflow"):
        os.mkdir(app + "/dataflow")
        
    dirs = os.walk("./" + app, False)
    for d in dirs:
        dirname = d[0].replace("./" + app + "/", "")
        if dirname.startswith("dataflow"):
            break
        print d[0], dirname
        dirname = app + "/dataflow/" + dirname
        if not os.path.isdir(dirname):
            os.system("mkdir -p " + dirname)
        for file in d[2]:
            filepath = d[0] + "/" + file
            if file.endswith(".rb"):
                operation = "jrubyc " + filepath + " > tmp.log"
                print operation 
                os.system(operation)
                filename = dirname + "/" +  file.replace(".rb", ".log")
                operation = "sed '1,87111d' tmp.log > " + filename
                print operation
                os.system(operation)
def main():
    if len(sys.argv) != 2:
        print "usage: python generate_dataflow.py APPNAME"
    else:
        generate_dataflow(sys.argv[1])
        
if __name__ == '__main__':
    main()