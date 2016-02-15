def compare_consequent_actions(prev_list, next_list)
	@tables = Hash.new

	prev_list.each do |pn|
		if pn.isQuery?
			if pn.getInstr.getCallHandler != nil and pn.getInstr.getCallHandler.caller != nil
				tbl_name = pn.getInstr.getCallHandler.caller.getName
				if @tables[tbl_name] == nil
					@tables[tbl_name] = Array.new
				end
				@tables[tbl_name].push(pn)
			end	
		end
	end
	
	@next_tables = Hash.new
	next_list.each do |n|
		if n.isQuery?
			if n.getInstr.getCallHandler != nil and n.getInstr.getCallHandler.caller != nil
				tbl_name = n.getInstr.getCallHandler.caller.getName
				if @tables[tbl_name] != nil
					if @next_tables[tbl_name] == nil
						@next_tables[tbl_name] = Array.new
					end
					@next_tables[tbl_name].push(n)
				end
			end
		end
	end	

	@tables.each do |k, v|
		if @next_tables[k] != nil
			puts "Table #{k} operation overlap:"
			puts "\tPrevious action queries:"
			v.each do |n|
				puts "\t\t#{n.getIndex}: (#{n.getInstr.getCallHandler.complete_string.gsub("\n"," ")})"
			end
			puts "\tNext action queries:"
			@next_tables[k].each do |n|
				puts "\t\t#{n.getIndex}: (#{n.getInstr.getCallHandler.complete_string.gsub("\n"," ")})"
			end
		end
	end
	puts "================="
	puts ""
end
