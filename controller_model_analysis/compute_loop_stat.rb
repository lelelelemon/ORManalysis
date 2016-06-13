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

	$graph_file.puts("<loopWhile>")
	@closure_cnt = Array.new
	@while_cnt = Array.new
	$node_list.each do |n|
		if n.getInstr.hasClosure? and isNonClosureInstr(n.getInstr) == false
			@closure_cnt.push(n)
		end 
		if n.getInstr.in_while_loop
			@while_cnt.push(n.getInstr.in_while_loop) unless @while_cnt.include?(n.getInstr.in_while_loop)
		end 
	end
	$graph_file.puts("\t<while>#{@while_cnt.length}<\/while>")
	$graph_file.puts("\t<closure>#{@closure_cnt.length}<\/closure>")
	$graph_file.puts("<\/loopWhile>")

end



def compute_loop_carry_dep
	$node_list.each do |n|
		if n.getInstr.hasClosure?
			#find closure variables
			@closure_vars = Array.new
			n.getInstr.getClosure.getBB[1].getInstr.each do |instr|
				if instr.instance_of?ReceiveArg_instr
					@closure_vars.push(instr.getDefv)
				end
			end
		
			@used_vars = Array.new
			#get all the used variables that escape the closure
			n.getInstr.getClosure.var_def_table.each do |dep|
				@used_vars.push(dep.getVname) unless @closure_vars.include? dep.getVname 
			end

			@def_vars = Array.new
			n.getInstr.getClosure.closure_def_table.each do |dep|
				@def_vars.push(dep.getVname) unless @closure_vars.include? dep.getVname 
			end

			@def_vars.each do |d|
				if @used_vars.include?(d) 
					n.getInstr.getClosure.has_loop_carry_dep = true
					$temp_file.puts " ++ loop #{n.getIndex} has loop carry dependence because of var #{d}"
				end
			end
		end
	end
end

def test_in_while_loop(node)
	if node.getInstr.in_while_loop
		return true
	end
	if node.getInClosure
		node.getNonViewClosureStack.each do |cl|
			if cl.getInstr.in_while_loop
				return true
			end
		end
	end
	return false
end
