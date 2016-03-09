def is_chained_query(qnode)
	qnode.getDataflowEdges.each do |e|
		if e.getToNode.isReadQuery? and qnode.getDataflowEdges.length == 1
			return true
		end
	end
	return false
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
