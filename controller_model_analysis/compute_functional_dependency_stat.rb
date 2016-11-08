def analyse_functional_dependencies
	find_interesting_nodes
end

def find_interesting_nodes
	$statistics = Hash.new
	$query_nodes = Set.new
	content = ""
	$node_list.each do |n|
		if n.getInstr.is_a?Call_instr and ["save", "save!"].include?n.getInstr.getFuncname
			table_name = type_valid(n.getInstr, n.getInstr.getCaller)
			content += get_xml("action", trace_data_dependency_till_source(n, 0, [], is_root: true), attributes: [["table", table_name]])
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
		analysis_content += explore_query_nodes
		info_file.puts get_xml("analysis", analysis_content)
		info_file.close
	end
end

def increment_statistics(key)
	unless key.nil?
		if $statistics.has_key?key
			$statistics[key] += 1
		else
			$statistics[key] = 1
		end
	end
end

def explore_query_nodes()
	query_nodes_array = $query_nodes.to_a
	content = ""
	count = 0
	query_nodes_array.each do |node|
		query_content = ""
		if node.getInstr.getQueryType != "INSERT" and node.getInstr.getAssociationType == nil
			query_content += get_xml("instruction", node.getInstr.toString, attributes: [["index", node.getIndex.to_s], ["type", node.getInstr.getQueryType], ["function", node.getInstr.getFuncname]])
			query_content += get_xml("dataflow", trace_dataflow_of_query(node, 0, []))
		else
			query_content += get_xml("instruction", node.getInstr.toString, attributes: [["index", node.getIndex.to_s], ["type", node.getInstr.getQueryType], ["function", node.getInstr.getFuncname], ["association", node.getInstr.getAssociationType]])
		end
		content += get_xml("query", query_content)
		count += 1
	end
	return get_xml("queries", content, attributes: ["count", count.to_s])
end

def trace_dataflow_of_query(node, distance, visited_nodes)
	#node details
	instruction_index = -1
	instruction_type = "unknown"
	instruction_content = ""

	children_count = 0
	children_content = ""
	explore_children = false

	if node == nil
		#this corresponds to an user-input
		instruction_type = "user-input"
		#increment_statistics("USER-INPUT")
	else
		children_count = node.getBackwardEdges.length
		instruction_content = node.getInstr.toString
		instruction_index = node.getIndex

		if isUtilSource(node)
			instruction_type = "utility"
			increment_statistics("UTILITY")
		elsif isConstSource(node)
			instruction_type = "constant"
			if children_count == 0
				increment_statistics("CONSTANT")
			else
				explore_children = true
			end
		elsif node.isQuery?
			instruction_type = "query"
			query_type = node.getInstr.getQueryType
			increment_statistics(query_type)
			$query_nodes.add(node)
			explore_children = true
		elsif node.getInstr.is_a?Call_instr
			instruction_type = node.getInstr.getFuncname
			if instruction_type != "build" and instruction_type != "new"
				explore_children = true
			end
		else
			instruction_type = "unknown"
			explore_children = true
		end

		node_content = get_xml("instruction", instruction_content, attributes: [["type", instruction_type]], escape_content: true)

		#children details
		if children_count > 0 and \
				not visited_nodes.include?(node.getIndex) and \
				not node.getInstr.toString.include?"before_" and \
				explore_children
			visited_nodes.push(node.getIndex)
			#perform a depth first traversal
			node.getBackwardEdges.each do |edge|
				children_content += trace_data_dependency_till_source(edge.getFromNode, distance + 1, visited_nodes)
			end
			visited_nodes.delete(node.getIndex)
			node_content += get_xml("children", children_content, attributes: [["count", children_count]])
		end
	end

	return get_xml("node", node_content.to_s, attributes: [["index", instruction_index.to_s], ["distance", distance.to_s]])
end

def trace_data_dependency_till_source(node, distance, visited_nodes, is_root: false)
	#node details
	instruction_index = -1
	instruction_type = "unknown"
	instruction_content = ""

	children_count = 0
	children_content = ""
	explore_children = false

	if node == nil
		#this corresponds to an user-input
		instruction_type = "user-input"
		#increment_statistics("USER-INPUT")
	else
		children_count = node.getBackwardEdges.length
		instruction_content = node.getInstr.toString
		instruction_index = node.getIndex

		if isUtilSource(node)
			instruction_type = "utility"
			increment_statistics("UTILITY")
		elsif isConstSource(node)
			instruction_type = "constant"
			if children_count == 0
				increment_statistics("CONSTANT")
			else
				explore_children = true
			end
		elsif node.isQuery?
			instruction_type = "query"
			query_type = node.getInstr.getQueryType
			increment_statistics(query_type)
			$query_nodes.add(node)
			if is_root
				explore_children = true
			end
		elsif node.getInstr.is_a?Call_instr
			instruction_type = node.getInstr.getFuncname
			if instruction_type != "build" and instruction_type != "new"
				explore_children = true
			end
		else
			instruction_type = "unknown"
			explore_children = true
		end

		node_content = get_xml("instruction", instruction_content, attributes: [["type", instruction_type]], escape_content: true)

		#children details
		if children_count > 0 and \
				not visited_nodes.include?(node.getIndex) and \
				not node.getInstr.toString.include?"before_" and \
				explore_children
			visited_nodes.push(node.getIndex)
			#perform a depth first traversal
			node.getBackwardEdges.each do |edge|
				children_content += trace_data_dependency_till_source(edge.getFromNode, distance + 1, visited_nodes)
			end
			visited_nodes.delete(node.getIndex)
			node_content += get_xml("children", children_content, attributes: [["count", children_count]])
		end
	end

	return get_xml("node", node_content.to_s, attributes: [["index", instruction_index.to_s], ["distance", distance.to_s]])
end

def post_process_functional_dependencies
	content = File.read("#{$app_dir}/fdAnalysis.xml")
	File.delete("#{$app_dir}/fdAnalysis.xml")
	info_file = File.open("#{$app_dir}/fdAnalysis.xml", "w")
	info_file.puts get_xml("app", content)
	info_file.close
end
