$QNODECOLOR = "coral1"
$USERINOUTCOLOR = "cyan3"


#backward
$query_depends_on = Array.new
#forward
$query_determines = Array.new
#backward
$query_depends_on_cflow = Array.new
#forward
$query_determines_cflow = Array.new

def traceback_data_dep(cur_node, stop_at_query=false)
	@dep_array = Array.new
	@node_list = Array.new
	@node_list.push(cur_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		node.getBackwardEdges.each do |e|
			if e.getFromNode != nil and e.getToNode != nil
				if e.getFromNode.isReadQuery?
					if @dep_array.include?(e.getFromNode)
					else
						@dep_array.push(e.getFromNode)
					end
					if stop_at_query
						return e.getFromNode
					end	
				else
					#if cur_node.getCallStack.include?(e.getToNode) and e.getVname == "returnv"
					if e.getFromNode.getIndex < cur_node.getIndex
					#else
						#test is both nodes are in the same basic block, prevent from tracing too far
						#if e.getFromNode.getInstr.getBB == node.getInstr.getBB
						if @dep_array.include?(e.getFromNode)
						else
							@dep_array.push(e.getFromNode)
							@node_list.push(e.getFromNode)
						end
					end
				end
			elsif e.getFromNode == nil and e.getToNode != nil
				#TODO: this is a bit annoying... if the type in @dep_array is Edge, then it is user input, otherwise other instruction nodes
				@dep_array.push(e)
			end
		end
	end
	if stop_at_query
		return nil
	else
		return @dep_array
	end
end

#for a query, if it is like the form v = Vote.where(...)
#Given the query instruction Vote.where
#return the assign instruction v =
#so that we can know the result of the query is put into the variable v
#Or it can be like if Vote.where(...)
#Stops at a nearest var define or branch instr
#TODO: any other possiblilities?
def find_nearest_var(cur_node)
	@node_list = Array.new
	@node_list.push(cur_node)
	@traversed = Array.new
	while @node_list.length > 0 do
		node = @node_list.pop
		@traversed.push(node)
		node.getDataflowEdges.each do |e|
			if e.getToNode.getInstr.getDefv != nil 
				if e.getToNode.getInstr.getDefv.include?('%') == false
					return e.getToNode
				#elsif e.getToNode.getInstr.getDefv.include?("self")
				#	return e.getToNode
				end
			elsif e.getToNode.getInstr.instance_of?AttrAssign_instr and e.getToNode.getInstr.getCaller.include?("self")
				return e.getToNode
			else
				if @node_list.include?(e.getToNode) or @traversed.include?(e.getToNode)
				else
					if e.getToNode.getInstr.getBB == cur_node.getInstr.getBB
						@node_list.push(e.getToNode)
					end
				end
			end
		end
	end
	return nil
end

def traceforward_data_dep(query_node)
	@traversed = Array.new
	@node_list = Array.new
	@node_list.push(query_node)
	while @node_list.length > 0 do
		node = @node_list.pop
		@traversed.push(node)
		node.getDataflowEdges.each do |e|
			#e.getToNode will never be nil
			#if e.getToNode.isTableField?
			#	#check caller name matches
			#	var_name = e.getToNode.getInstr.getCallHandler.getObjName
			#	f_name = e.getToNode.getInstr.getCallHandler.getFuncName
			#	if (self_v_name == nil or self_v_name != var_name) and e.getToNode.getInstr.instance_of?AttrAssign_instr
			#		@traversed.push(e.getToNode)
			#	else
			#		if @node_list.include?(e.getToNode) == false and @traversed.include?(e.getToNode) == false
			#			@node_list.push(e.getToNode)
			#		end	
			#	end
			#	#puts "\t* Field #{var_name} . #{f_name} is being used"
			#	#cur_node must define sth
			#	#if cur_node.getDefv == var_name
			#		#puts "#{var_name} . #{e.getToNode.getInstr.getCallHandler.getFuncName} from [query] #{query_node.getInstr.toString} is used"
			#	#end
			#if e.getToNode.getInView
				#@traversed.push(e.getToNode)
			if e.getToNode.isQuery? and e.getToNode != query_node
				if @traversed.include?(e.getToNode)
				else
					@traversed.push(e.getToNode)
					@node_list.push(e.getToNode)
				end
			elsif @node_list.include?(e.getToNode) or @traversed.include?(e.getToNode)
			else
				if e.getToNode.getInstr.instance_of?Return_instr
					e.getToNode.getDataflowEdges.each do |e1|
						if e1.getToNode.getIndex <= query_node.getIndex or @traversed.include?(e1.getToNode)
						else
							@node_list.push(e1.getToNode)
						end
					end
				elsif e.getToNode.getIndex > query_node.getIndex
					@node_list.push(e.getToNode)
				end
			end
		end
	end
	@traversed.shift
	return @traversed
end

def print_dataflow_graph
	$node_list.each do |n|
		print "Node #{n.getIndex}: "
		n.getDataflowEdges.each do |d|
			print "n#{d.getToNode.getIndex}, "
		end
		puts ""
	end
end

def construct_query_graph
	$node_list.each do |n1|
		if n1.isQuery?
			$node_list.each do |n2|
				if n2.isQuery?
					connected = false
					$global_check = Hash.new
					if is_directly_connected(n1, n2)
						graph_write($graph_file, "n#{n1.getIndex} -> n#{n2.getIndex}\n")
					end
				end
			end
		end
	end		
end

def print_query_graph(output_dir, start_class, start_function)

	graph_fname = "#{output_dir}/#{start_class}_#{start_function}_Qgraph.log"
	$graph_file = File.open(graph_fname, "w");

	graph_write($graph_file, "digraph #{remove_special_chars(start_class)}_#{start_function} {\n")
	print_graph2(start_class, start_function)
	graph_write($graph_file, "}");

	$graph_file.close
end

def print_graph2(start_class, start_function)
	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end

	#$graph_file.write
	#traverse_instr_tree($root, 0)

	#start constructing query graph	
	construct_query_graph
	$node_list.each do |n|
		if n.isQuery?
			if n.getInClosure == false
				graph_write($graph_file, "\tn#{n.getIndex} [label=<<i>#{n.getLabel}</i>>]; \n")
			else
				graph_write($graph_file, "\tn#{n.getIndex} [label=<<i>#{n.getLabel}</i>> style=filled color=orange]; \n")
			end
		end
	end
	##end constructing query graph

	#print_dataflow_graph

	#$node_list.each do |n|
	#	print "node #{n.getIndex}: "
	#	n.getChildren.each do |c|
	#		print "#{c.getIndex}, "
	#	end
	#	puts ""
	#end
end

$computed_node = nil

class Temp_Qgeneral_stat
	def initialize
		@total = 0
		@in_closure = 0
		@in_view = 0
		@total_branch = 0	
		@branch_dependon_query = 0
	end
	attr_accessor :total, :in_closure, :in_view, :total_branch, :branch_dependon_query
end

class Temp_Qsink_stat < Temp_Qgeneral_stat
	def initialize
		super
		@to_read_query = 0
		@to_write_query = 0
		@to_branch = 0
		@to_view = 0
		@sink_total = 0
	end
	attr_accessor :to_read_query, :to_write_query, :to_branch, :to_view, :sink_total
end

class Temp_Qsource_stat < Temp_Qgeneral_stat
	def initialize
		super
		@source_total = 0
		@from_query = 0
		@from_const = 0
		@from_util = 0
		@from_user_input = 0
	end
	attr_accessor :from_query, :from_const, :from_user_input, :source_total, :from_util
end

class Temp_singleQ_stat
	def initialize
		@result_used_in_view = 0
		@only_from_user_input = 0
	end
	attr_accessor :result_used_in_view, :only_from_user_input
end

class Temp_view_stat
	def initialize
		@table_list = Array.new
		@field_list = Array.new
	end
	attr_accessor :table_list, :field_list
	def addTable(t)
		if @table_list.include?t
		else
			@table_list.push(t)
		end
	end
	def addField(f)
		if @field_list.include?f
		else
			@field_list.push(f)
		end
	end
end

def compute_dataflow_stat(output_dir, start_class, start_function, build_node_list_only=false)

	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		addAllControlEdges
		compute_source_sink_for_all_nodes
		if $cfg == nil
			return
		end
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end
	
	$node_list.each do |n|
		n.setLabel
		puts "#{n.getIndex}:#{n.getInstr.toString}"
		#if n.getInClosure
		#	if n.getInView and n.getClosureStack.length == 1
		#	else
		#		s = ""
		#		n.getClosureStack.each do |n1|
		#			s += "#{n1.getIndex}," 
		#		end
		#		puts "\t * IN CLOSURE (#{n.isQuery?})  [#{s}]"
		#	end
		#end
		if n.getInstr.is_a?Call_instr
			caller_type = type_valid(n.getInstr, n.getInstr.getCaller)
			puts "\tcallert #{n.getInstr.getCallerType}; isQuery? #{n.getInstr.isQuery}; isReadQuery? #{n.getInstr.isReadQuery}; isTableField? #{n.getInstr.isTableField}; isClassField? #{n.getInstr.isClassField}" 
			if n.getInstr.getDefv != nil
				puts "\t\treturn type: #{type_valid(n.getInstr, n.getInstr.getDefv)}"
			end
		end
		n.getBackwardEdges.each do |e|
			if e.getFromNode != nil
				#puts "\t\t (#{e.getVname})<- #{e.getFromNode.getIndex}: #{e.getFromNode.getInstr.toString}"
			else
				#puts "\t\t <- params"
			end
		end
		n.getControlflowEdges.each do |e|
			#puts "\t\t -> #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString} (#{e.getToNode.path_length})"
		end
	end

	exit

	if build_node_list_only
				#puts "#{n.getIndex}: Forward ARRAY length: #{@forwardarray.length}  (write: #{temp_to_write}) (stat: #{@read_sink_stat.to_write_query})"
		return
	end


	@clique_stat = Array.new
	graph_fname = "#{output_dir}/sketch_graph.log"
	$graph_file = File.open(graph_fname, "w")

	build_sketch_graph
	cliques = getCliqueList(10)
	i = 0
	cliques.each do |c|
		i = i + 1
		#puts "CLIQUE: #{i}"
		#c.each do |n|
		#	puts "\t#{n.getIndex}: #{n.getInstr.toString2} (#{n.getInstr.getTableName})"
		#end
		if c.length > 1
			@different_tables = Array.new
			c.each do |n|
				if @different_tables.include?(n.getInstr.getTableName)
				else
					@different_tables.push(n.getInstr.getTableName)
				end
			end
			if @different_tables.length > 1
				@clique_stat.push(c.length)
			end
		end
	end

	$graph_file.close

	graph_fname = "#{output_dir}/stats.xml"
	$graph_file = File.open(graph_fname, "w")
	$graph_file.puts("<STATSHEADER>")

	#compute_functional_dependency($graph_file)

	total_query_num = 0
	query_in_closure = 0
	query_in_view = 0
	query_read = 0
	query_write = 0
	branch_dependon_query = 0
	total_branch = 0

	cnt_materialized_query = 0	

	write_source_total = 0	
	write_from_const = 0
	write_from_user_input = 0
	write_from_query = 0
	#The whoe query
	read_to_read_query = 0
	read_to_write_query = 0
	read_to_view = 0
	read_to_branch = 0

	@general_stat = Temp_Qgeneral_stat.new
	@read_sink_stat = Temp_Qsink_stat.new
	@write_source_stat = Temp_Qsource_stat.new
	@read_source_stat = Temp_Qsource_stat.new
	@singleQ_stat = Temp_singleQ_stat.new
	@view_stat = Temp_view_stat.new

	@table_read_stat = Hash.new
	@table_write_stat = Hash.new
	@table_general_stat = Hash.new

	@validation_stat = Hash.new

	$node_list.each do |n|
		if n.isQuery?
			@general_stat.total += 1
			@table_name = n.getInstr.getTableName
			if @table_name == nil
				@table_name = "UNKNOWN"
			end
			if @table_read_stat.has_key?(@table_name)
			else
				@table_read_stat[@table_name] = Temp_Qsink_stat.new
			end
			if @table_write_stat.has_key?(@table_name)
			else
				@table_write_stat[@table_name] = Temp_Qsource_stat.new
			end
			if @table_general_stat.has_key?(@table_name)
			else
				@table_general_stat[@table_name] = Temp_Qgeneral_stat.new
			end
			@table_general_stat[@table_name].total += 1

			n.getValidationStack.each do |vl|
				if @validation_stat[vl]
				else
					@validation_stat[vl] = 0
				end
				@validation_stat[vl] += 1
			end

			if n.getInClosure
				@general_stat.in_closure += 1
				@table_general_stat[@table_name].in_closure += 1
				
				if n.getInView
					#graph_write($graph_file, " (v)")
					@general_stat.in_view += 1
					@table_general_stat[@table_name].in_view += 1
				end
				if n.getInView and n.getClosureStack.length == 1
					@general_stat.in_closure -= 1
					@table_general_stat[@table_name].in_closure -= 1
				else #n.getInView == false or n.getClosureStack.length > 1
					#graph_write($graph_file, " (c)")
				end
			end
			if n.isReadQuery?
				@read_sink_stat.total += 1
				@read_source_stat.total += 1
				@table_read_stat[@table_name].total += 1
				#puts "READ query instr #{n.getIndex}:#{n.getInstr.toString} forward flow:"
				#v_node = find_nearest_var(n)
				#self_v_name = nil
				#if v_node != nil
				#	if v_node.getInstr.getDefv != nil
				#		self_v_name = v_node.getInstr.getDefv
				#	else #AttrAssign_instr
				#		self_v_name = v_node.getInstr.getFuncname
				#	end
				#end
				#if self_v_name != nil
				#	#puts "* #{n.getIndex}:#{n.getInstr.toString} result into #{self_v_name}"
				#	cnt_materialized_query += 1
				#	#graph_write($graph_file, " into_#{self_v_name}")
				#end
				#puts "Forward length = #{traceforward_data_dep(n).length}"
				@used_in_view = false
				@forwardarray = traceforward_data_dep(n)
				@forwardarray.each do |n1|
					#if n1.isTableField?
					#	var_name = n1.getInstr.getCallHandler.getObjName
					#	field_name = n1.getInstr.getCallHandler.getFuncName
					#	if (self_v_name == nil or self_v_name != var_name) and n1.getInstr.instance_of?AttrAssign_instr
					#			read_assign_to_other += 1
					#			single_tbl_assign_to_other += 1
					#			#puts "\t(read_assign_to_other)"
					#	end
					#elsif n1.getInstr.instance_of?AttrAssign_instr and n1.getInstr.getCaller.include?("self")
					#	read_assign_to_self += 1
					#	single_tbl_assign_to_self += 1
					#	#puts "\t(read_assign_to_self)"
					#if n1.getInView
						#puts " * (To view)"
						#@table_read_stat[@table_name].to_view += 1
						#@read_sink_stat.to_view += 1
						#@table_read_stat[@table_name].sink_total += 1
						#@read_sink_stat.sink_total += 1
					if n1.isQuery?
						@table_read_stat[@table_name].sink_total += 1
						@read_sink_stat.sink_total += 1
						if n1.isWriteQuery?
								@read_sink_stat.to_write_query += 1
								@table_read_stat[@table_name].to_write_query += 1
								#puts " * (To write query)"
						else
								@read_sink_stat.to_read_query += 1
								@table_read_stat[@table_name].to_read_query += 1
								#puts " * (To read query)"
						end
					elsif n1.isBranch?
						@table_read_stat[@table_name].sink_total += 1
						@read_sink_stat.sink_total += 1
						@read_sink_stat.to_branch += 1
						@table_read_stat[@table_name].to_branch += 1
						#puts " * (To branch)"
					elsif n1.getDataflowEdges.length == 0
						@table_read_stat[@table_name].sink_total += 1
						@read_sink_stat.sink_total += 1
						if n1.getInView
							@table_read_stat[@table_name].to_view += 1
							@read_sink_stat.to_view += 1
						else
						#puts " * (To unknown sink)"
						end
					end
					if n1.getInView
						@used_in_view = true
					end
					#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				end
				
				if @used_in_view
					@singleQ_stat.result_used_in_view += 1
				end
				@only_from_user_input = true
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						@read_source_stat.from_user_input += 1
						@read_source_stat.source_total += 1
					elsif n1.isQuery?
						@read_source_stat.from_query += 1
						@read_source_stat.source_total += 1
						@only_from_user_input = false
					elsif n1.getBackwardEdges.length == 0
						@read_source_stat.source_total += 1
						if n1.getInstr.instance_of?Copy_instr and n1.getInstr.isFromConst
							@read_source_stat.from_const += 1
						elsif n1.getInstr.instance_of?Const_instr
							@read_source_stat.from_util += 1 
						end
					end
				end
				if @only_from_user_input
					@singleQ_stat.only_from_user_input += 1
				end
			end
			if n.isWriteQuery?
				@write_source_stat.total += 1
				@table_write_stat[@table_name].total += 1
				#puts "READ / DELETE/UPDATE/INSERT instr #{n.getIndex}:#{n.getInstr.toString} backflow:"
				#puts "backward length = #{traceback_data_dep(n).length}"
				@only_from_user_input = true
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						#puts " x (From user input)"
						@write_source_stat.from_user_input += 1
						@write_source_stat.source_total += 1
						@table_write_stat[@table_name].from_user_input += 1
						@table_write_stat[@table_name].source_total += 1
					else
						if n1.isQuery? 
							@only_from_user_input = false
							if n1.isReadQuery?
								@write_source_stat.from_query += 1
								@write_source_stat.source_total += 1
								@table_write_stat[@table_name].from_query += 1
								@table_write_stat[@table_name].source_total += 1
								#puts " x (From query)"
							else
								#puts " (#{n.getInstr.toString}) depend on (#{n1.getInstr.toString})"
							end
						elsif n1.getBackwardEdges.length == 0
							if n1.getInstr.instance_of?Copy_instr and n1.getInstr.isFromConst
								#puts " x (From copy const)"
								@write_source_stat.from_const += 1
								@table_write_stat[@table_name].from_const += 1
							elsif n1.getInstr.instance_of?Const_instr
								@write_source_stat.from_util += 1
							else
								#puts " x (Some source)"
							end
							@write_source_stat.source_total += 1
							@table_write_stat[@table_name].source_total += 1
						end
						#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
					end
				end
				if @only_from_user_input
					@singleQ_stat.only_from_user_input += 1
				end
			end
			#graph_write($graph_file, "\n")
	
		elsif n.isBranch?
			@general_stat.total_branch += 1
		 	q = traceback_data_dep(n, true)
			if q != nil
				@general_stat.branch_dependon_query += 1
				#puts "Branch depend on query:  #{q.getInstr.getCallHandler.getObjName} . #{q.getInstr.getCallHandler.getFuncName}"
			end
		end
	end

	$node_list.each do |n|
		if n.getInView
			if n.isQuery?
				tbl_name = n.getInstr.getTableName
				@view_stat.addTable(tbl_name)
			elsif n.isTableField?
				tbl_name = type_valid(n.getInstr, n.getInstr.getCaller)
				field_name = n.getInstr.getFuncname
				f = testTableField(tbl_name, field_name)
				if f != nil
					@view_stat.addField("#{tbl_name}.#{field_name}")
				end
			end 
		elsif n.isTableField?
			@used_in_view = false
			tbl_name = type_valid(n.getInstr, n.getInstr.getCaller)
			field_name = n.getInstr.getFuncname
			f = testTableField(tbl_name, field_name)
			if f != nil
				traceforward_data_dep(n).each do |n1|
					if n1.getInView
						@used_in_view = true
						break
					end
				end
				if @used_in_view
					@view_stat.addField("#{tbl_name}.#{field_name}")
					@view_stat.addTable(tbl_name)
				end
			end 
		end
	end

	$graph_file.puts("<stat>")
	$graph_file.puts("\t<general>")
	helper_print_stat(@general_stat, @read_sink_stat, @read_source_stat, @write_source_stat, "STATS")
	$graph_file.puts("\t\t<queryOnlyFromUser>#{@singleQ_stat.only_from_user_input}<\/queryOnlyFromUser>")
	$graph_file.puts("\t\t<queryUsedInView>#{@singleQ_stat.result_used_in_view}<\/queryUsedInView>")
	$graph_file.puts("\t<\/general>")

	@table_general_stat.each do |k, v|
		$graph_file.puts("\t<#{k}>")
		helper_print_stat(v, @table_read_stat[k], nil, @table_write_stat[k], k, false)
		$graph_file.puts("\t<\/#{k}>")
	end
	$graph_file.puts("<\/stat>")
	$graph_file.puts("")


	$graph_file.puts("<viewStats>")
	@view_stat.table_list.each do |t|
		$graph_file.puts("\t<table>#{t}<\/table>")
	end
	@view_stat.field_list.each do |f|
		$graph_file.puts("\t<field>#{f}<\/field>")
	end
	$graph_file.puts("<\/viewStats>")

	$graph_file.puts("<cliqueStat>")
	@validation_stat.each do |k, vd|
		$graph_file.puts("\t<validation>#{vd}<\/validation>")
	end
	@clique_stat.each do |cq|
		$graph_file.puts("\t<clique>#{cq}<\/clique>")
	end
	$graph_file.puts("<\/cliqueStat>")
			
	$graph_file.puts("<chainStats>")
	compute_chain_stats
	$graph_file.puts("<\/chainStats>")

	$graph_file.puts("<singlePath>")
	compute_longest_single_path	
	$graph_file.puts("<\/singlePath>")

	$graph_file.puts("<schema>")
	compute_schema_design_stat($graph_file)
	$graph_file.puts("<\/schema>")
	
	#if $query_depends_on.length > 0	
	#	graph_write($graph_file, "query backward dependencies: #{($query_depends_on.inject{|sum,x| sum + x })/($query_depends_on.length)}\n")
	#end
	#
	#if $query_determines.length > 0
	#	graph_write($graph_file, "query forward dependencies: #{($query_determines.inject{|sum,x| sum + x })/$query_determines.length}\n")
	#end
	#
	#if $query_determines_cflow.length + $query_depends_on_cflow.length > 0
	#	graph_write($graph_file, "query controlflow_dep: #{($query_depends_on_cflow.inject{|sum,x| sum + x }+$query_determines_cflow.inject{|sum,x| sum + x })/($query_depends_on_cflow.length+$query_determines_cflow.length)}\n")
	#end
	
	$graph_file.puts("<\/STATSHEADER>")	
	$graph_file.close
	#number of query functions
	#number of tables  --- Hard to know. If Comment.where(story_id <= 1).first, second "story" table will not be detected
	#number of query functions within loop
	#number of queries in view


end

def helper_print_stat(general, readSink, readSource, write, label, print_branch=true)
	$graph_file.puts("\t\t<queryTotal>#{general.total}<\/queryTotal>")

	$graph_file.puts("\t\t<queryInView>#{general.in_view}<\/queryInView>")
	$graph_file.puts("\t\t<queryInClosure>#{general.in_closure}<\/queryInClosure>")

	if print_branch
		$graph_file.puts("\t\t<branchOnQuery>#{general.branch_dependon_query}<\/branchOnQuery>")
		$graph_file.puts("\t\t<branchTotal>#{general.total_branch}<\/branchTotal>")
	end

	$graph_file.puts("\t\t<readSink>")
	$graph_file.puts("\t\t\t<total>#{readSink.total}<\/total>")
	$graph_file.puts("\t\t\t<sinkTotal>#{readSink.sink_total}<\/sinkTotal>")
	$graph_file.puts("\t\t\t<toReadQuery>#{readSink.to_read_query}<\/toReadQuery>")
	$graph_file.puts("\t\t\t<toWriteQuery>#{readSink.to_write_query}<\/toWriteQuery>")
	$graph_file.puts("\t\t\t<toView>#{readSink.to_view}<\/toView>")
	$graph_file.puts("\t\t\t<toBranch>#{readSink.to_branch}<\/toBranch>")
	$graph_file.puts("\t\t<\/readSink>")

	if readSource
		$graph_file.puts("\t\t<readSource>")
		$graph_file.puts("\t\t\t<total>#{readSource.total}<\/total>")
		$graph_file.puts("\t\t\t<sourceTotal>#{readSource.source_total}<\/sourceTotal>")
		$graph_file.puts("\t\t\t<fromUserInput>#{readSource.from_user_input}<\/fromUserInput>")
		$graph_file.puts("\t\t\t<fromUtil>#{readSource.from_util}<\/fromUtil>")
		$graph_file.puts("\t\t\t<fromQuery>#{readSource.from_query}<\/fromQuery>")
		$graph_file.puts("\t\t\t<fromConst>#{readSource.from_const}<\/fromConst>")
		$graph_file.puts("\t\t<\/readSource>")
	end

	$graph_file.puts("\t\t<writeSource>")
	$graph_file.puts("\t\t\t<total>#{write.total}<\/total>")
	$graph_file.puts("\t\t\t<sourceTotal>#{write.source_total}<\/sourceTotal>")
	$graph_file.puts("\t\t\t<fromUserInput>#{write.from_user_input}<\/fromUserInput>")
	$graph_file.puts("\t\t\t<fromUtil>#{write.from_util}<\/fromUtil>")
	$graph_file.puts("\t\t\t<fromQuery>#{write.from_query}<\/fromQuery>")
	$graph_file.puts("\t\t\t<fromConst>#{write.from_const}<\/fromConst>")
	$graph_file.puts("\t\t<\/writeSource>")
end
