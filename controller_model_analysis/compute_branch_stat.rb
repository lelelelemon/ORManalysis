def branch_queries
	@branch_on_query_cnt = Hash.new
	$node_list.each do |n|
		if n.isBranch?
			qn_list = traceback_data_dep(n)
			qn = nil
			qn_list.each do |q|
				if q.instance_of?INode and q.isReadQuery? and (qn == nil or q.getIndex > qn.getIndex)
					qn = q
				end
			end
			if qn
				_key = qn.getInstr.getFuncname
				if _key.include?("find_by")
					key = "find_by"
				elsif $key_words[_key]
					key = _key.gsub('?','').gsub('!','')
				else
					key = "association"
				end
				@branch_on_query_cnt[key] = 0 unless @branch_on_query_cnt.has_key?(key)
				@branch_on_query_cnt[key] += 1
				
				puts "branch depend on Q: #{qn.getIndex}:#{qn.getInstr.toString}"
			end
		end
	end
	$graph_file.puts "<branchOnQueryType>"
	@branch_on_query_cnt.each do |k, v|
		$graph_file.puts "\t<#{k}>#{v}<\/#{k}>"
	end
	$graph_file.puts "<\/branchOnQueryType>"
end


def test_trivial_branch(qnode, ary)
	@branch_list = Array.new
	if is_chained_query(qnode)
		return @branch_list
	end
	#puts "#{qnode.getIndex}: #{qnode.getInstr.toString2}"
	ary.each do |n|
		if n.isBranch?
			@path = find_path_between_two_nodes(qnode, n)
			@trivial = true
			@str = ""
			@path.each do |p|
				@str += "#{p.getIndex}, "
				if p.isReadQuery?
					@trivial = false
				end
			end
			for i in 0...@path.length-1
				@path[i].getDataflowEdges.each do |n1|
					if n1.getToNode == @path[i+1]
						if n1.getVname.include?("self")
							@trivial = false
						end
						if n1.getVname.include?('%')
						else
							@trivial = false
						end
					end
				end
			end
			if @trivial
				#puts "\t[BRANCH] #{n.getIndex}:#{n.getInstr.toString2} (pathlen = #{@path.length} [#{@str}])"
				@branch_list.push(n)
			end
		end
	end
	return @branch_list
end 
