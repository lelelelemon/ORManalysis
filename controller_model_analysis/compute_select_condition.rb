def add_to_table_select_fields(class_name, field_name)
	if $table_select_fields[class_name]
	else
		$table_select_fields[class_name] = Hash.new
	end
	if $table_select_fields[class_name].has_key?(field_name)
	else
		$table_select_fields[class_name][field_name] = 0
	end
	$table_select_fields[class_name][field_name] += 1
end

def trace_query_select_condition(qnode)
	#find_by
	if qnode.getInstr.getFuncname.include?("find_by")
		fname = qnode.getInstr.getFuncname.tr("find_by_","")
		if testTableField(qnode.getInstr.getTableName, fname)
			add_to_table_select_fields(qnode.getInstr.getTableName, fname)
			#puts "ADD select by find_by: #{qnode.getIndex}: #{qnode.getInstr.getTableName}.#{fname}"
		end
	end
	#select condition: hash
	qnode.getBackwardEdges.each do |e|
		if e.getFromNode.getInstr.instance_of?HashField_instr
			e.getToNode.getInstr.hash_fields.each do |h|
				if testTableField(qnode.getInstr.getTableName, h)
					add_to_table_select_fields(qnode.getInstr.getTableName, h)
					#puts "ADD select by hash: #{qnode.getIndex}: #{qnode.getInstr.getTableName}.#{h}"
				end	
			end	
		end
	end	
	#select condition: symbol
	qnode.getInstr.symbols.each do |s|
		if testTableField(qnode.getInstr.getTableName, s)
			add_to_table_select_fields(qnode.getInstr.getTableName, s)
			puts "ADD select by symbol: #{qnode.getIndex}: #{qnode.getInstr.getTableName}.#{s}"
		end
	end
	#select condition: const string
	qnode.getBackwardEdges.each do |e|
		if e.getFromNode.getInstr.instance_of?Copy_instr
			str = e.getFromNode.getInstr.const_string
			if str
				chs = str.split(" ")
				chs.each do |c|
					if testTableField(qnode.getInstr.getTableName, c)
						add_to_table_select_fields(qnode.getInstr.getTableName, c)
					end
				end
			end
		end
	end
end

def compute_select_condition
	$graph_file.puts "<selectCondition>"
	$node_list.each do |n|
		if n.isReadQuery?
			trace_query_select_condition(n)
		end
	end

	$table_select_fields.each do |k,v|
		v.each do |vk, vv|
			$graph_file.puts "\t<#{k} field=\"#{vk}\">#{vv}<\/#{k}>"	
		end
	end

	$graph_file.puts "<\/selectCondition>"
end
