import glob
import os
apppath = "."
controller_path = "%s/merged_controllers/*.rb"%(apppath)
model_path = "%s/models/*.rb"%(apppath)

despath = "%s/dataflow/"%(apppath)
des_controller = "%s/merged_controllers/"%(despath)
des_model = "%s/models/"%(despath)

for filename in glob.iglob(controller_path):
	print filename
	n_begin = filename.rfind('/')
	n_end = filename.rfind('.')
	class_name = filename[n_begin+1:n_end]
	print class_name
	des_file = "%s/%s.log"%(des_controller,class_name)
	os.system("/home/congy/jruby/bin/jrubyc %s >> %s"%(filename, des_file))



for filename in glob.iglob(model_path):
	print filename
	n_begin = filename.rfind('/')
	n_end = filename.rfind('.')
	class_name = filename[n_begin+1:n_end]
	print class_name
	des_file = "%s/%s.log"%(des_model,class_name)
	os.system("/home/congy/jruby/bin/jrubyc %s >> %s"%(filename, des_file))
