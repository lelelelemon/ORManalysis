def analyse_functional_dependencies
	find_interesting_nodes
end

def find_interesting_nodes
	$statistics = Hash.new

	content = ""
	$node_list.each do |n|
		if n.getInstr.is_a?Call_instr and ["save", "save!"].include?n.getInstr.getFuncname
			table_name = type_valid(n.getInstr, n.getInstr.getCaller)
			content += get_xml("action", trace_complete_data_dependency_graph(n, 0, [],print_query: true), attributes: [["table", table_name]])
		end
	end

	if(content != "")
		info_file = File.open("#{$app_dir}/fdAnalysis.xml", "a")
		analysis_content = get_xml("actions", content)
		statistics_content = ""
		$statistics.keys.each do |k|
			statistics_content += get_xml(k, $statistics[k].to_s)
		end
		analysis_content += get_xml("statistics", statistics_content)
		info_file.puts get_xml("analysis", analysis_content)
		info_file.close
	end
end

def increment_statistics(key)
	if($statistics.has_key?key)
		$statistics[key] += 1
	else
		$statistics[key] = 1
	end
end

def trace_complete_data_dependency_graph(node, distance, visited_nodes, print_query: false)
	#node details
	instruction_index = -1
	instruction_type = "unknown"
	instruction_content = ""

	children_count = 0
	children_content = ""

	if node == nil
		instruction_type = "user-input"
	else
		children_count = node.getBackwardEdges.length
		#the current node is a leaf.
		instruction_content = node.getInstr.toString
		instruction_index = node.getIndex
		if isUtilSource(node)
			instruction_type = "utility"
			increment_statistics("UTILITY")
		elsif isConstSource(node)
			instruction_type = "constant"
			if children_count == 0
				increment_statistics("CONSTANT")
			end
		elsif node.isQuery?
			instruction_type = "query"
			query_type = node.getInstr.getQueryType
			increment_statistics(query_type)
		else
			instruction_type = "unknown"
		end

		#children details
		if children_count > 0 and not visited_nodes.include?(node.getIndex) and (instruction_type != "query" || print_query)
			visited_nodes.push(node.getIndex)
			#perform a depth first traversal
			node.getBackwardEdges.each do |edge|
				children_content += trace_complete_data_dependency_graph(edge.getFromNode, distance + 1, visited_nodes)
			end
			visited_nodes.delete(node.getIndex)
		end

	end

	if(children_content != "")
		node_content = get_xml("instruction", instruction_content, attributes: [["type", instruction_type]], escape_content: true)
		node_content += get_xml("children", children_content, attributes: [["count", children_count]])
		return get_xml("node", node_content, attributes: [["index", instruction_index.to_s], ["distance", distance.to_s]])
	elsif instruction_type != "user-input" and instruction_type != "unknown"
		node_content = get_xml("instruction", instruction_content, attributes: [["type", instruction_type]], escape_content: true)
		return get_xml("node", node_content, attributes: [["index", instruction_index.to_s], ["distance", distance.to_s]])
	else
		return ""
	end
end

def post_process_functional_dependencies
	content = File.read("#{$app_dir}/fdAnalysis.xml")
	File.delete("#{$app_dir}/fdAnalysis.xml")
	info_file = File.open("#{$app_dir}/fdAnalysis.xml", "w")
	info_file.puts get_xml("app", content)
	info_file.close
end
