def compute_loop_invariant

	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	puts "~~~~~~~~~~~~~Handling loop invariant~~~~~~~~~~~~~~~~~"


	@closures = Array.new
	@query_loops = Array.new
	$node_list.each do |n|
		if n.isReadQuery?
			if n.getInClosure
				if n.getNonViewClosureStack.length > 0
						@closures |= n.getNonViewClosureStack
				end
			end
		end
		# "query loop"
		#if n.getInstr.instance_of?Copy_instr and /IN.*\(SELECT/.match(n.getInstr.const_string)
		#	@query_loops.push(n.getInstr) unless @query_loops.include?(n.getInstr)
		#end 
	end
	@results = Array.new
	@instr_rd = {}
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

			
			
			write_tables = []
			#puts "clnodes size is #{@cl_nodes.length}"
			@cl_nodes.each do |cl_n|
				# if the variable is def self, it can be added to the loop variant
				if cl_n.getInstr.getDefv and cl_n.getInstr.getDefv.include?("self")
					@loop_inv.push(cl_n) unless @loop_inv.include?(cl_n)
					#puts "self #{cl_n.getInstr.getDefv}"
				# if the variable is not self, but its data dependency are all out of the closure
			    elsif cl_n.getInstr.getDefv and (traceback_data_dep(cl_n) & @cl_nodes).empty? and !traceback_data_dep(cl_n).empty?
			    	# ReceiveArg_instr is the loop condition
			    	if cl_n.getInstr.instance_of?ReceiveArg_instr 
			    		next
			    	end
			    	isLambda = false
			    	# To check whether the loop is inside a lambda loop
			    	traceback_data_dep(cl_n).each do |dc|
						# puts "tc #{dc.getInstr.toString}"
						if !dc.instance_of?Dataflow_edge and dc.getInstr.instance_of?Call_instr 
							fname = dc.getInstr.getFuncname
							if fname == 'lambda' or fname == 'cache_if'  or fname == 'cache'
								puts "fname : #{fname}"
								isLambda = true
								break
							end
						end
					end
					if isLambda 
						next
					end
					@loop_inv.push(cl_n) unless @loop_inv.include?(cl_n)
					#puts "no dep #{cl_n.getInstr.toString}"
			    end
				if cl_n.isWriteQuery?
					write_table = cl_n.getInstr.getTableName
					write_tables.push(write_table) unless write_tables.include?(write_table)
				end
			end
			write_tables.each do |wt|
				#puts "write table #{wt}"
			end
			# test whether there are read_query who touches the same table with the write query
			@loop_inv.each do |li|
				if li.isReadQuery? and write_tables.include?(li.getInstr.getTableName)
					@loop_inv.delete(li)
				end
			end
			#puts "loop_inv size is #{@loop_inv.length}"
			
			#puts "write_tables size is #{write_tables.length}"
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
				#puts li.getInstr.toString
				if li.isReadQuery? 
					next if li.getInstr.getCaller == '%self'
					@results.push([li,cl]) unless (@results.include?([li,cl]) || @results.map { |e| e.first }.include?(li))
				end
			end

	end

	puts "the number of loop in query is : #{@results.length}" if @results.length > 0
	cnt = 1
	result_group_cl = @results.group_by{|re| re[1]}
	result_group_cl.each do |cl, res|
		res.each do |re|
			puts "#{cnt} query" 
			puts re[0].getInstr.toString
			cnt += 1
		end
		cl.getInstr.getClosure.self_print
	end
	@query_loops.each do |ql|
		puts ql.getInstr.toString
	end

	puts "~~~~~~~~~~~~~Finish handling loop invariant~~~~~~~~~~~"
	puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
end


