#==============================Global hash table for classes, tables, etc========================
#key: class name (String); value: class structure (Class_class)
$class_map = Hash.new
$table_names = Array.new
#key: database query functions (String); value: query type (String) 
$key_words = Hash.new
#key: utility function (String); value: function return value type (String) 
$util_function_list = Hash.new
#key: query word; value: count
$query_word_count = Hash.new
#key: query function; value: count
$query_func_count = Hash.new
#==============================

#==============================Directories=================
$app_dir = "../applications/lobsters"
$schema_file = "../applications/lobsters/schema.rb"
$dataflow_dir = "../applications/lobsters/dataflow/"
$table_file = "../applications/lobsters/table_names.txt"
$log_files = "" #deprecated

$output_dir = "."
$trace_output_file = ""
$graph_file = nil
$temp_file = nil
#==============================

#=============================Variables used for reading app file and constructing classes/functions, etc=============
#(Function_call)
$cur_funccall = nil
#(String)
$cur_position = "" #test whether a statement is in some condition or not
#(Method_class)
$cur_method = nil
#(Class_class)
$cur_class = nil
#==============================


#=========================Global variables used when tracing a controller action (building call graph), some are deprecated===========
#when find unique method by name, ignore these methods...
$ignore_method_list = Array.new
#Used in trace_flow.rb, keep track of traced methods(String)
$non_repeat_list = Array.new
#Some functions are repeatable, tailored for each app
$non_repeatable_list = Array.new
#key: "#{from_node_index}*#{to_node_index}" (String); value: (Dataflow_edge)
$dataflow_edges = Hash.new
#(INode), for only query nodes
$sketch_node_list = Array.new

$global_check = Hash.new
$cur_query_stack = Array.new
$query_edges = Array.new
#==============================



#======================build_dataflow_graph.rb, stacks to keep track of nested view/transaction/loop, etc==========
$in_view = false
$in_loop = Array.new
$in_validation = Array.new
$general_call_stack = Array.new
$funccall_stack = Array.new
$call_stack_trace = Array.new
$cur_query_stack = Array.new
$closure_stack = Array.new
$def_self_nodes = Hash.new
#==============================


#==========================Dataflow root and node list=============
$root = nil
$cfg = nil
$ins_cnt = 0
#store all instruction node
$node_list = Array.new
#the very source of dataflow, all nodes using user input connect to this node
#format: from_inode_index*to_inode_index
#==============================

#=======================trace_flow.rb, mostly deprecated====================
$l_index = 0
$blank = ""
$in_view = false
$last_caller_string = ""
#==============================


#==========================Temporary global variables used when reading dataflow log=================
$view_ruby_code = false
$view_closure = false
$cur_bb_stack = Array.new
$cur_cfg_stack = Array.new
$cur_cfg = nil
$cfg_map = Hash.new
$cur_bb = nil
#==============================


