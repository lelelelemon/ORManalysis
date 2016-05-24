def compute_loop_stat
	$graph_file.puts("<loopNestedStats>")
	@loop_hash = Hash.new
	$node_list.each do |n|
		if n.getInClosure
			n.getNonViewClosureStack.each do |cl|
				@loop_hash[cl] = cl.getNonViewClosureStack.length+1
			end
		end
	end
	@loop_hash.each do |k, v|
		$graph_file.puts("\t<depth>#{v}<\/depth>")
	end
	$graph_file.puts("<\/loopNestedStats>")
end
