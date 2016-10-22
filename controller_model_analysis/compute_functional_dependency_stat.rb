def compute_assignment_source
	#key: table_name.column_name
	#value: an array of source
	@column_assignments = Hash.new
	$node_list.each do |n|
		#Assignments: 1.explicit assign like comment.text = params[:text]
		#             2.write_attribute... functions (this list may not be complete)
		@table_name = nil
		@column_names = Array.new
		if n.getInstr.instance_of?AttrAssign_instr 
			@table_name = type_valid(n.getInstr, n.getInstr.getCaller)
			if testTableField(@table_name, n.getInstr.getFuncname)
				@column_names.push(n.getInstr.getFuncname)
			end
		elsif  (n.getInstr.is_a?Call_instr and ["write_attribute","update_attribute","update_column","update_columns","update_attributes", "save"].include?n.getInstr.getFuncname)
			@table_name = type_valid(n.getInstr, n.getInstr.getCaller)
			#update_column(:text), ':text' is symbol
			for s in n.getInstr.symbols
				@column_names.push(s)
			end
			#if update_columns doesn't have any symbol, highly likely it is the case that all columns are updated (not 100% sure)
			if ["update_columns","update_attributes", "save"].include?n.getInstr.getFuncname and n.getInstr.symbols.length == 0
				if @table_name and $class_map[@table_name]
					$class_map[@table_name].getTableFields.each do |f|
						@column_names.push(f.field_name)
					end
				end
			end
		end
		if @table_name != nil and @column_names.length > 0
			#trace back the data flow graph from the current assignment node
			@sources = Array.new
			traceback_data_dep_for_funcdep(n).each do |pn|
				#from user input
				if pn.instance_of?Dataflow_edge
					@sources.push("user_input")
				elsif pn.isQuery?
					@sources.push("#{pn.getInstr.getTableName}")
					#@sources.push("#{pn.getInstr.getTableName}.#{pn.getInstr.getFuncname}")
				#source node in the graph
				elsif pn.getBackwardEdges.length == 0 
					if isUtilSource(pn)
						@sources.push("util_func")
						#@source.push("util_func:#{pn.getInstr.getFuncname}")
					elsif isConstSource(pn)
						@sources.push("user_input")
					end
				end
			end
			#debug
			@str = "columns ("
			@column_names.each do |c|
				key = "#{@table_name}.#{c}"
				@column_assignments[key] = Array.new unless @column_assignments.has_key?(key)
				@column_assignments[key] << @sources
			end
			@str += @column_names.join(", ")
			@str += ") from table #{@table_name} take sources: "
			@str += @sources.join(",")
			puts @str
		end
	end

	#print out the assignments for each column in this action
	$graph_file.puts "<assignmentDetail>"
	@column_assignments.each do |k, v|
		$graph_file.puts "\t<#{k}>#{v}<\/#{k}>" 
	end
	$graph_file.puts "<\/assignmentDetail>"
end
