def compute_loop_invariant

	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	puts "~~~~~~~~~~~~~Handling loop invaraint~~~~~~~~~~~~~~~~~"


	@closures = Array.new
	$node_list.each do |n|
		if n.isReadQuery?
			if n.getInClosure
				if n.getNonViewClosureStack.length > 0
						@closures |= n.getNonViewClosureStack
				end
			end
		end
	end
	@results = Array.new
	@closures.each do |cl|
			@cl_nodes = Array.new
			if !cl.getInstr.getClosure
				next
			end
			cl.getInstr.getClosure.getBB.each do |bb|
				bb.getInstr.each do |i|
					@cl_nodes.push(i.getINode)
				end
			end

			@loop_inv = Array.new

			cl_dep = traceback_data_dep(cl)
			write_tables = []
			#puts "clnodes size is #{@cl_nodes.length}"
			@cl_nodes.each do |cl_n|
				# if the variable is def self, it can be added to the loop variant
				if cl_n.getInstr.getDefv and cl_n.getInstr.getDefv.include?("self")
					@loop_inv.push(cl_n) unless @loop_inv.include?(cl_n)
					#puts "self #{cl_n.getInstr.toString}"
				# if the variable is not self, but its data dependency are all out of the closure
			    elsif !cl_n.getInstr.getDefv and (traceback_data_dep(cl_n) & @cl_nodes).empty? and !traceback_data_dep(cl_n).empty?
			    	@loop_inv.push(cl_n) unless @loop_inv.include?(cl_n)
			    	traceback_data_dep(cl_n).each do |td|
			    		#uts td.getInstr.toString
			    	end
					#puts "no dep #{cl_n.getInstr.toString}"
			    end
				if cl_n.isWriteQuery?
					write_table = cl_n.getInstr.getTableName
					write_tables.push(write_tables) unless write_tables.include?(Qu_table)
				end
			end
			write_tables.each do |wt|
				puts "write table #{wt}"
			end
			# test whether there are read_query who touches the same table with the write query
			@loop_inv.each do |li|
				if li.isReadQuery? and write_tables.include?(li.getInstr.getTableName)
					@loop_inv.delete(li)
				end
			end
			puts "loop_inv size is #{@loop_inv.length}"
			
			puts "write_tables size is #{write_tables.length}"
			@loop_stack = @loop_inv.dup
			while(true)
				if @loop_stack.empty?
					break
				end
				l = @loop_stack.pop
				children = traceforward_data_dep(l)
				#puts "the size of children is : #{children.length}"
				#puts "#{l.getInstr.toString}"
				#puts "children"
				children.each do |child|
					 #puts "child.getInstr: #{child.getInstr.toString}"
					 if @cl_nodes.include?(child) and ((traceback_data_dep(child) - @loop_inv) & @cl_nodes).empty?
					 	if child.isReadQuery? and write_tables.include?(child.getInstr.getTableName)
							next
						end 
					 	@loop_inv.push(child) unless @loop_inv.include?(child)
					 	@loop_stack.push(child) unless @loop_stack.include?(child)
					 end 
				end
			end
			#puts "After popping loop_inv size is #{@loop_inv.length}"
			@loop_inv.each do |li|
				puts li.getInstr.toString
				if li.isReadQuery? 
					self_cnt = 0
					traceback_data_dep(li).each do |tdd|
						self_cnt += 1 if !tdd.instance_of?Dataflow_edge and tdd.getInstr.getDefv and tdd.getInstr.getDefv.include?("self")
					 	
					end
					next if self_cnt == traceback_data_dep(li).length
					@results.push([li,cl]) unless (@results.include?([li,cl]) || @results.map { |e| e.first }.include?(li))
				end
			end

	end

	puts "the number of loop in query is : #{@results.length}" if @results.length > 0
	cnt = 1
	@results.each do |re|
		puts "#{cnt} query" 
		puts re[0].getInstr.toString
		cnt += 1
		re[1].getInstr.getClosure.self_print
	end


	puts "~~~~~~~~~~~~~Finish handling loop invariant~~~~~~~~~~~"
	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
end


