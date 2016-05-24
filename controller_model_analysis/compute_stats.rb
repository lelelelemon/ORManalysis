$QNODECOLOR = "coral1"
$USERINOUTCOLOR = "cyan3"

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

def compute_dataflow_stat(output_dir, start_class, start_function, build_node_list_only=false)

	if $root == nil
		$cfg = trace_query_flow(start_class, start_function, "", "", 0)
		addAllControlEdges
		compute_source_sink_for_all_nodes
		if $cfg == nil
			return
		end
		if $cfg.getBB[0] == nil or $cfg.getBB[0].getInstr[0] == nil
			exit
		end
		$root = $cfg.getBB[0].getInstr[0].getINode	
	end
	
	$node_list.each do |n|
		n.setLabel
		$temp_file.puts "#{n.getIndex}:#{n.getInstr.toString}"
		if n.getValidationStack.length > 0
			str = ""
			n.getValidationStack.each do |v|
				str += "#{v.getIndex}, "
			end
			$temp_file.puts "\t * \t validation #{str}"
		end
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
			$temp_file.puts "\tcallert #{n.getInstr.getCallerType}; isQuery? #{n.getInstr.isQuery}; isReadQuery? #{n.getInstr.isReadQuery}; isTableField? #{n.getInstr.isTableField}; isClassField? #{n.getInstr.isClassField}"
			if n.isQuery?
				#puts "\t * table_name = #{n.getInstr.getTableName}"
			end 
			if n.getInstr.getDefv != nil
				#puts "\t\treturn type: #{type_valid(n.getInstr, n.getInstr.getDefv)}"
			end
		end
		n.getDataflowEdges.each do |e|
			if e.getToNode != nil
				$temp_file.puts "\t\t -> [#{e.getVname}] #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString}"
			else
				#puts "\t\t <- params"
			end
		end
		n.getControlflowEdges.each do |e|
			#$temp_file.puts "\t\t (DF) -> #{e.getToNode.getIndex}: #{e.getToNode.getInstr.toString} (#{e.getToNode.path_length})"
		end
	end

	@func_dep_file = File.open("#{output_dir}/func_dep.xml", "w")
	@func_dep_file.puts("<funcDep>")
	compute_functional_dependency(@func_dep_file)
	@func_dep_file.puts("<\/funcDep>")
	@func_dep_file.close
	@trivial_branches = Array.new
	@query_to_trivial_branch = Array.new

	if build_node_list_only
				#puts "#{n.getIndex}: Forward ARRAY length: #{@forwardarray.length}  (write: #{temp_to_write}) (stat: #{@read_sink_stat.to_write_query})"
		return
	end

=begin
	@clique_stat = Array.new
	graph_fname = "#{output_dir}/sketch_graph.log"
	$graph_file = File.open(graph_fname, "w")

	#build_sketch_graph
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
=end

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
	cnt_not_materialized_query = 0

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
	@const_stat = Temp_const_stat.new

	@table_read_stat = Hash.new
	@table_write_stat = Hash.new
	@table_general_stat = Hash.new

	@validation_stat = Hash.new

	$node_list.each do |n|
		if n.isQuery?
			n.getValidationStack.each do |vl|
				if @validation_stat[vl]
				else
					@validation_stat[vl] = Temp_validation_stat.new
					@validation_stat[vl].depth = vl.getValidationStack.length
				end
				@validation_stat[vl].addQuery(n)
				@validation_stat[vl].addQuery(vl)
				if n.isReadQuery?
					@validation_stat[vl].read += 1
				else
					@validation_stat[vl].write += 1
				end
			end
		end
	end
	#add single-write txn
	#$node_list.each do |n|
	#	if n.isWriteQuery?
	#		if @validation_stat.key?(n)
	#		else
	#			@validation_stat[n] = Temp_validation_stat.new
	#			@validation_stat[n].addQuery(n)
	#		end
	#	end
	#end

	@query_length_graph = Hash.new
	$node_list.each do |n|
		if n.isReadQuery?
			@query_length_graph[n] = Array.new
		end
	end
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


			if n.getInClosure
				if n.getNonViewClosureStack.length > 0
					@general_stat.in_closure += 1
					@table_general_stat[@table_name].in_closure += 1
					by_db = false
					str = ""
					n.getNonViewClosureStack.each do |cl|
						if traceback_data_dep(cl, true)
							by_db = true
							str += "(DB)"
						end
						str += "#{cl.getIndex}, "
					end
					if by_db
						@general_stat.in_closure_by_db += 1
						@table_general_stat[@table_name].in_closure_by_db += 1
					end
					$temp_file.puts "query #{n.getIndex} in closure : #{str}"

				end
				if n.getInView
					#graph_write($graph_file, " (v)")
					@general_stat.in_view += 1
					@table_general_stat[@table_name].in_view += 1
				end
			end
			if n.isReadQuery?
				if check_scope_query_string(n)
					@read_source_stat.from_query_string += 1
					@general_stat.use_query_string += 1
					@table_general_stat[@table_name].use_query_string += 1
				else
					check_query_function(n)
				end
				@read_sink_stat.total += 1
				@read_source_stat.total += 1
				@table_read_stat[@table_name].total += 1
				#puts "READ query instr #{n.getIndex}:#{n.getInstr.toString} forward flow:"
				v_node = find_nearest_var(n)
				_key = n.getInstr.getFuncname
				if n.getInstr.getCallHandler
					_key = n.getInstr.getCallHandler.getFuncName
				end
				key = _key.gsub('?','').gsub('!','')
				if _key.include?("find_by")
					key = "find_by"
				elsif $key_words[_key]
					key = _key.gsub('?','').gsub('!','')
				else
					key = "association"
				end
				if $query_return_record.include?(key)
					if v_node
						#AttrAssign or closure
						if v_node.getInstr.getDefv != nil
							#if check_necessary_materialization(v_node, v_node.getInstr.getDefv)
								cnt_materialized_query += 1
						else
							cnt_materialized_query += 1
						end
					elsif is_chained_query(n)==false
						cnt_not_materialized_query += 1
						$temp_file.puts("Query #{n.getIndex} result not materialized")
					end
				end
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
				#temp_b = test_trivial_branch(n, @forwardarray)
				#if temp_b.length > 0
				#	@trivial_branches += temp_b
				#	@query_to_trivial_branch.push(n)
				#end

				#if n.getIndex == 1190
				#	str = ""
				#	@forwardarray.each do |f|
				#		str += "#{f.getIndex}, "
				#	end
				#	puts "1190 forward array: #{str}"
				#end
			
				#Queries in validations need to be executed sequentially	
				n.getValidationStack.each do |vl|
					@validation_stat[vl].queries.each do |q|
						if q.getIndex > n.getIndex
							@query_length_graph[n].push(q)
						end
					end
				end
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
						if @query_length_graph[n].include?(n1)
						else
							@query_length_graph[n].push(n1)
						end

						@table_read_stat[@table_name].sink_total += 1
						@read_sink_stat.sink_total += 1
						#puts "QUERY: #{n.getIndex}: #{n.getInstr.toString}"
						if n1.isWriteQuery?
								@read_sink_stat.to_write_query += 1
								@table_read_stat[@table_name].to_write_query += 1
								#in txn: read goes to write
								n.getValidationStack.each do |vl|
									if @validation_stat[vl].queries.include?(n1)
										@validation_stat[vl].addReadGoesToWrite(n)
									end
								end
								#puts " * (To write query)"
						else
								@read_sink_stat.to_read_query += 1
								@table_read_stat[@table_name].to_read_query += 1
								#puts " * (To read query)"
						end
					elsif n1.getDataflowEdges.length == 0
						if sinkIgnore(n1) == false
							@table_read_stat[@table_name].sink_total += 1
							@read_sink_stat.sink_total += 1
						end
						if n1.isBranch?
							#$temp_file.puts "#Q #{n.getIndex} reaches branch #{n1.getIndex}"
							n.getValidationStack.each do |vl|
								@validation_stat[vl].queries.each do |w|
									if w.isWriteQuery?
										#puts "\tREachable? (#{w.getIndex}) <- (#{n1.getIndex}) #{is_controlflow_reachable(w, n1)}"
										if is_controlflow_reachable(w, n1)
											@validation_stat[vl].addReadGoesToBranchOnWrite(n)
											#puts "\t\t* branch affect write #{w.getIndex}"
										end
									end
								end
							end
						end
						if n1.getInView
								@table_read_stat[@table_name].to_view += 1
								@read_sink_stat.to_view += 1
						elsif n1.isBranch?
							@read_sink_stat.to_branch += 1
							@table_read_stat[@table_name].to_branch += 1
							#puts " * (To branch) #{n1.getIndex}:#{n1.getInstr.toString}"
						#elsif n1.getDataflowEdges.length == 0
						elsif isValidationSink(n1)
							@table_read_stat[@table_name].to_validation += 1
							@read_sink_stat.to_validation += 1
						elsif isCacheSink(n1)
							@table_read_stat[@table_name].to_browser_cache += 1
							@read_sink_stat.to_browser_cache += 1
						elsif sinkIgnore(n1)==false
								#puts " * (To unknown sink) #{n1.getIndex}: #{n1.getInstr.toString}"
						end
						if n1.getInView
							@used_in_view = true
						end
					end
					#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
				end
				
				if @used_in_view
					@singleQ_stat.result_used_in_view += 1
				end
				@only_from_user_input = true
				@used_query_string = false
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						@read_source_stat.from_user_input += 1
						@read_source_stat.source_total += 1
					elsif n1.isQuery?
						@read_source_stat.from_query += 1
						@read_source_stat.source_total += 1
						@only_from_user_input = false
					elsif n1.getBackwardEdges.length == 0
						if sourceIgnore(n1)
						else
							@read_source_stat.source_total += 1
						end
						if isConstSource(n1)
							#Test query string
							is_query_string = check_query_string(n, n1)
							if is_query_string
								@used_query_string = true
								@read_source_stat.from_query_string += 1
							elsif isSelectCondition(n1)
								@read_source_stat.from_select_condition += 1
							else
								$temp_file.puts " x (#{n.getIndex} From copy const #{n1.getIndex}: #{n1.getInstr.toString})"
								@read_source_stat.from_const += 1
								analyzeConstSource(n1, @const_stat)
							end
						elsif isUtilSource(n1)
							#$temp_file.puts " x (#{n.getIndex} From Util #{n1.getIndex}: #{n1.getInstr.toString})" 
							@read_source_stat.from_util += 1
						elsif n1.getInstr.instance_of?GlobalVar_instr
							@read_source_stat.from_global += 1
						elsif sourceIgnore(n1) == false
							#puts " x (Some source) #{n1.getIndex}:#{n1.getInstr.toString}"
						end
					end
				end
				if @only_from_user_input
					@singleQ_stat.only_from_user_input += 1
					$temp_file.puts "# query #{n.getIndex} only uses user input"
				end
				if @used_query_string
					@general_stat.use_query_string += 1
					@table_general_stat[@table_name].use_query_string += 1
				end
			end
			if n.isWriteQuery?
				has_source = false
				@write_source_stat.total += 1
				@table_write_stat[@table_name].total += 1
				#puts "READ / DELETE/UPDATE/INSERT instr #{n.getIndex}:#{n.getInstr.toString} backflow:"
				#puts "backward length = #{traceback_data_dep(n).length}"
				@only_from_user_input = true
				traceback_data_dep(n).each do |n1|
					if n1.instance_of?Dataflow_edge
						has_source = true
						#puts " x (From user input)"
						@write_source_stat.from_user_input += 1
						@write_source_stat.source_total += 1
						@table_write_stat[@table_name].from_user_input += 1
						@table_write_stat[@table_name].source_total += 1
					else
						if n1.isQuery? 
							@only_from_user_input = false
							if n1.isReadQuery?
								has_source = true
								@write_source_stat.from_query += 1
								@write_source_stat.source_total += 1
								@table_write_stat[@table_name].from_query += 1
								@table_write_stat[@table_name].source_total += 1
								#puts " x (From query)"
							else
								#puts " (#{n.getInstr.toString}) depend on (#{n1.getInstr.toString})"
							end
						elsif n1.getBackwardEdges.length == 0
							if isSelectCondition(n1)
								has_source = true
								@write_source_stat.from_select_condition += 1
								@table_write_stat[@table_name].from_select_condition += 1
							elsif isConstSource(n1)
								has_source = true
								$temp_file.puts " x (#{n.getIndex} From copy const #{n1.getIndex}: #{n1.getInstr.toString})"
								@write_source_stat.from_const += 1
								analyzeConstSource(n1, @const_stat)
								@table_write_stat[@table_name].from_const += 1
							elsif isUtilSource(n1)
								has_source = true
								#$temp_file.puts " x (#{n.getIndex} From Util #{n1.getIndex}: #{n1.getInstr.toString})" 
								@write_source_stat.from_util += 1
							elsif n1.getInstr.instance_of?GlobalVar_instr
								@write_source_stat.from_global += 1
							elsif sourceIgnore(n1) == false
								#puts " x (Some source) #{n1.getIndex}:#{n1.getInstr.toString}"
							end
							if sourceIgnore(n1)
							else
								@write_source_stat.source_total += 1
								@table_write_stat[@table_name].source_total += 1
							end
						end
						#puts "\t--\t#{n1.getIndex}:#{n1.getInstr.toString}"
					end
				end
				if has_source == false
					#$temp_file.puts "Write Query #{n.getIndex} has no source"
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
				#$temp_file.puts "Branch  #{n.getIndex} depend on QUERY #{q.getIndex}"
			else
				#$temp_file.puts "Branch on other #{n.getIndex}"
			end
			if n.getInView
				@general_stat.branch_in_view += 1
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

#compute longest query chain length
	@temp_length_graph = Hash.new
	@longest_query_len = 0
	$node_list.reverse_each do |n|
		if @query_length_graph.has_key?(n)
			@q = @query_length_graph[n]
			@temp_length_graph[n] = 1
			if @q.length > 0
				@q.each do |inner_q|
					if @temp_length_graph[inner_q] == nil
					elsif @temp_length_graph[n] < @temp_length_graph[inner_q]+1
						@temp_length_graph[n] = @temp_length_graph[inner_q]+1
					end
				end
			end
			if @temp_length_graph[n] > @longest_query_len
				@longest_query_len = @temp_length_graph[n]
			end
		end
	end


	$graph_file.puts("<stat>")
	$graph_file.puts("\t<general>")
	helper_print_stat(@general_stat, @read_sink_stat, @read_source_stat, @write_source_stat, "STATS")
	$graph_file.puts("\t\t<queryOnlyFromUser>#{@singleQ_stat.only_from_user_input}<\/queryOnlyFromUser>")
	$graph_file.puts("\t\t<longestQueryPath>#{@longest_query_len}<\/longestQueryPath>")
	$graph_file.puts("\t\t<queryUsedInView>#{@singleQ_stat.result_used_in_view}<\/queryUsedInView>")
	#$graph_file.puts("\t\t<queryToTrivialBranch>#{@query_to_trivial_branch.length}<\/queryToTrivialBranch>")
	#$graph_file.puts("\t\t<trivialBranch>#{@trivial_branches.length}<\/trivialBranch>")
	$graph_file.puts("\t\t<materialized>#{cnt_materialized_query}<\/materialized>")	
	$graph_file.puts("\t\t<notMaterialized>#{cnt_not_materialized_query}<\/notMaterialized>")	
	$graph_file.puts("\t<\/general>")

	@table_general_stat.each do |k, v|
		$graph_file.puts("\t<#{k}>")
		helper_print_stat(v, @table_read_stat[k], nil, @table_write_stat[k], k, false)
		$graph_file.puts("\t<\/#{k}>")
	end
	$graph_file.puts("<\/stat>")
	$graph_file.puts("")

	compute_loop_stat
	compute_input_stat
	compute_query_card_stat
	compute_redundant_usage
	compute_select_condition

	$graph_file.puts("<viewStats>")
	@view_stat.table_list.each do |t|
		$graph_file.puts("\t<table>#{t}<\/table>")
	end
	@view_stat.field_list.each do |f|
		$graph_file.puts("\t<field>#{f}<\/field>")
	end
	$graph_file.puts("<\/viewStats>")

	$graph_file.puts("<constStats>")
	@const_stat.getSources.each do |s,v|
		$graph_file.puts("\t<#{s}>#{v}<\/#{s}>")
	end
	$graph_file.puts("<\/constStats>")

	$graph_file.puts("<cliqueStat>")
	@validation_stat.each do |k, vd|
		str = ""
		vd.queries.each do |q|
			str += "#{q.getIndex}, "
		end
		#$temp_file.puts "VALIDATION: #{k.getIndex} -> #{str}"
		vd.queries.each do |q|
			if vd.read_goes_to_write.include?(q)
			elsif vd.read_goes_to_branch_on_write.include?(q)
			elsif q.isReadQuery?
				$temp_file.puts "Read #{q.getIndex} in txn #{k.getIndex} can be kicked out"
			end
		end	
		$graph_file.puts("\t<validation>")
		$graph_file.puts("\t\t<read>#{vd.read}<\/read>")
		$graph_file.puts("\t\t<write>#{vd.write+1}<\/write>")
		$graph_file.puts("\t\t<depth>#{vd.depth}<\/depth>")
		$graph_file.puts("\t\t<readToWrite>#{vd.read_goes_to_write.length}<\/readToWrite>")
		$graph_file.puts("\t\t<readToBranchOnWrite>#{vd.read_goes_to_branch_on_write.length}<\/readToBranchOnWrite>")
		vd.getOtherQueries.each do |q|
			$graph_file.puts("\t\t<validationTable>#{q.getInstr.getTableName}<\/validationTable>")
		end
		$graph_file.puts("\t<\/validation>")
	end
	#@clique_stat.each do |cq|
	#	$graph_file.puts("\t<clique>#{cq}<\/clique>")
	#end
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

	$graph_file.puts("<queryString>")
	printQueryStringFreq
	$graph_file.puts("<\/queryString>")

	$graph_file.puts("<queryFunction>")
	printQueryFunctionFreq
	$graph_file.puts("<\/queryFunction>")	
	
	
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
	$graph_file.puts("\t\t<queryInClosureByDB>#{general.in_closure_by_db}<\/queryInClosureByDB>")

	$graph_file.puts("\t\t<queryUseSQLString>#{general.use_query_string}<\/queryUseSQLString>")

	if print_branch
		$graph_file.puts("\t\t<branchOnQuery>#{general.branch_dependon_query}<\/branchOnQuery>")
		$graph_file.puts("\t\t<branchInView>#{general.branch_in_view}<\/branchInView>")
		$graph_file.puts("\t\t<branchTotal>#{general.total_branch}<\/branchTotal>")
	end

	$graph_file.puts("\t\t<readSink>")
	$graph_file.puts("\t\t\t<total>#{readSink.total}<\/total>")
	$graph_file.puts("\t\t\t<sinkTotal>#{readSink.get_sink_total}<\/sinkTotal>")
	$graph_file.puts("\t\t\t<toReadQuery>#{readSink.get_to_read_query}<\/toReadQuery>")
	$graph_file.puts("\t\t\t<toWriteQuery>#{readSink.get_to_write_query}<\/toWriteQuery>")
	$graph_file.puts("\t\t\t<toView>#{readSink.get_to_view}<\/toView>")
	$graph_file.puts("\t\t\t<toBranch>#{readSink.get_to_branch}<\/toBranch>")
	$graph_file.puts("\t\t<\/readSink>")

	if readSource
		$graph_file.puts("\t\t<readSource>")
		$graph_file.puts("\t\t\t<total>#{readSource.total}<\/total>")
		$graph_file.puts("\t\t\t<sourceTotal>#{readSource.get_source_total}<\/sourceTotal>")
		$graph_file.puts("\t\t\t<fromUserInput>#{readSource.get_from_user_input}<\/fromUserInput>")
		$graph_file.puts("\t\t\t<fromUtil>#{readSource.get_from_util}<\/fromUtil>")
		$graph_file.puts("\t\t\t<fromQuery>#{readSource.get_from_query}<\/fromQuery>")
		$graph_file.puts("\t\t\t<fromQueryString>#{readSource.get_from_query_string}</fromQueryString>")
		$graph_file.puts("\t\t\t<selectCondition>#{readSource.get_from_select_condition}</selectCondition>")
		$graph_file.puts("\t\t\t<fromConst>#{readSource.get_from_const}<\/fromConst>")
		$graph_file.puts("\t\t\t<fromGlobal>#{readSource.get_from_global}<\/fromGlobal>")
		$graph_file.puts("\t\t<\/readSource>")
	end

	$graph_file.puts("\t\t<writeSource>")
	$graph_file.puts("\t\t\t<total>#{write.total}<\/total>")
	$graph_file.puts("\t\t\t<sourceTotal>#{write.get_source_total}<\/sourceTotal>")
	$graph_file.puts("\t\t\t<fromUserInput>#{write.get_from_user_input}<\/fromUserInput>")
	$graph_file.puts("\t\t\t<fromUtil>#{write.get_from_util}<\/fromUtil>")
	$graph_file.puts("\t\t\t<fromQuery>#{write.get_from_query}<\/fromQuery>")
	$graph_file.puts("\t\t\t<selectCondition>#{write.get_from_select_condition}<\/selectCondition>")
	$graph_file.puts("\t\t\t<fromConst>#{write.get_from_const}<\/fromConst>")
	$graph_file.puts("\t\t\t<fromGlobal>#{write.get_from_global}<\/fromGlobal>")
	$graph_file.puts("\t\t<\/writeSource>")
end
