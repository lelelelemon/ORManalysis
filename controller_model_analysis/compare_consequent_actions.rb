def compare_consequent_actions(action_name, prev_list, next_list)
	@tables = Hash.new

	prev_list.each do |pn|
		if pn.isQuery?
			tbl_name = pn.getInstr.getCallerType
			if @tables[tbl_name] == nil
				@tables[tbl_name] = Array.new
			end
			@tables[tbl_name].push(pn)
		end
	end
	
	$graph_file.puts("<#{action_name}>")
	@next_tables = Hash.new
	next_list.each do |n|
		if n.isQuery?
			tbl_name = n.getInstr.getCallerType
			if @tables[tbl_name] != nil
				if @next_tables[tbl_name] == nil
					@next_tables[tbl_name] = Array.new
				end
				@next_tables[tbl_name].push(n)
			end
		end
	end	

	@tables.each do |k, v|
		if @next_tables[k] != nil
			@prev_fields_select = Array.new
			@next_fields_select = Array.new
			@prev_num_read = 0
			@prev_num_write = 0
			@next_num_read = 0
			v.each do |n|
				if n.isReadQuery?
					@prev_num_read += 1
				else
					@prev_num_write += 1
				end
				n.getBackwardEdges.each do |e|
					if e.getFromNode != nil and e.getFromNode.getInstr.instance_of?HashField_instr
						e.getFromNode.getInstr.hash_fields.each do |h|
							if @prev_fields_select.include?(h)
							else
								@prev_fields_select.push(h)
							end
						end	
					end
				end
			end
			@next_tables[k].each do |n|
				if n.isReadQuery?
					@next_num_read += 1
				end
				n.getBackwardEdges.each do |e|
					if e.getFromNode != nil and e.getFromNode.getInstr.instance_of?HashField_instr
						e.getFromNode.getInstr.hash_fields.each do |h|
							if @next_fields_select.include?(h)
							else
								@next_fields_select.push(h)
							end
						end	
					end
				end
			end

			$graph_file.puts("<#{k}>")
			$graph_file.puts("\t<stat>")
			$graph_file.puts("\t\t<prevRead>#{@prev_num_read}<\/prevRead>")
			$graph_file.puts("\t\t<prevWrite>#{@prev_num_write}<\/prevWrite>")
			$graph_file.puts("\t\t<nextRead>#{@next_num_read}<\/nextRead>")
			$graph_file.puts("\t<\/stat>")
			@prev_fields_select.each do |f|
				$graph_file.puts("\t<prevField>#{f}<\/prevField>")
			end
			@next_fields_select.each do |f|
				$graph_file.puts("\t<nextField>#{f}<\/nextField>")
			end
			$graph_file.puts("<\/#{k}>")
		end
	end
	$graph_file.puts("<\/#{action_name}>")
	#@tables.each do |k, v|
	#	if @next_tables[k] != nil
	#		puts "Table #{k} operation overlap:"
	#		puts "\tPrevious action queries:"
	#		v.each do |n|
	#			puts "\t\t#{n.getIndex}: (#{n.getInstr.getCallHandler.complete_string.gsub("\n"," ")})"
	#		end
	#		puts "\tNext action queries:"
	#		@next_tables[k].each do |n|
	#			puts "\t\t#{n.getIndex}: (#{n.getInstr.getCallHandler.complete_string.gsub("\n"," ")})"
	#		end
	#	end
	#end
	#puts "================="
	#puts ""
end
