$query_words_exact_match = ["DESC","ASC","JOIN","ON","AND","OR","NOT","IN","NULL","EXIST","UPDATE","INSERT","SELECT","LIMIT","GROUP","ORDER","LIKE"]
$query_words_include = ["SUM","MIN","MAX","COUNT"]

def check_scope_query_string(query_node)
	contain_query_string = false
	if query_node.getInstr.getCallHandler
		str = query_node.getInstr.getCallHandler.query_string
		if str
			chs = str.split(" ")
			chs.each do |c|
				if $query_words_exact_match.include?(c)
					if $query_word_count[c] == nil
						$query_word_count[c] = 0
					end
					$query_word_count[c] += 1
					contain_query_string = true
				end
				$query_words_include.each do |i|
					if c.include?(i)
						if $query_word_count[i] == nil
							$query_word_count[i] = 0
						end
						$query_word_count[i] += 1
						contain_query_string = true
					end
				end
			end
		end
	end
	return contain_query_string
end

def check_query_string(query_node, const_node)
	if const_node.getInstr.instance_of?Copy_instr and const_node.getInstr.const_string
		#TODO: Here we restrict that the query node is directly depend on query node
		direct_dependent = true
		#direct_dependent = false
		#query_node.getBackwardEdges.each do |e|
		#	if e.getToNode == const_node
		#		direct_dependent = true
		#	end
		#end
		if direct_dependent
			contain_query_string = false
			chs = const_node.getInstr.const_string.split(" ")
			chs.each do |c|
				if $query_words_exact_match.include?(c)
					if $query_word_count[c] == nil
						$query_word_count[c] = 0
					end
					$query_word_count[c] += 1
					contain_query_string = true
				end
				$query_words_include.each do |i|
					if c.include?(i)
						if $query_word_count[i] == nil
							$query_word_count[i] = 0
						end
						$query_word_count[i] += 1
						contain_query_string = true
					end
				end
			end
			return contain_query_string
		end
	end
	return false
end

def printQueryStringFreq
	$query_word_count.each do |w, f|
		$graph_file.puts("\t<#{w}>#{f}<\/#{w}>")
	end
end
