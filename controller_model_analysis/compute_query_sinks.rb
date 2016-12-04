require 'active_support/core_ext/string'
def analyse_query_sinks
	compute_query_only_used_for_queries
end

def get_sinks_as_xml(node)
  content = ""
  all_sinks_are_query=true
  query_sinks_count=0
  if $queries_and_sinks.has_key?(node)
    sinks = $queries_and_sinks[node]
    sinks.each do |sink|
      if sink.isQuery?
        content += get_xml("sink", sink.getInstr.toString, attributes: [["index", sink.getIndex], ["is_query_sink", sink.isQuery?.to_s]], escape_content: true)
        query_sinks_count += 1
      else
        all_sinks_are_query=false
      end
    end
    return get_xml("sinks", content, attributes: [["total_count", sinks.length.to_s], ["query_sinks_count", query_sinks_count.to_s], ["interesting", all_sinks_are_query.to_s]])
  else
    return ""
  end
end

def find_forward_query_functions(node, query_blob)
	continue = true
	while continue
		if node.getDataflowEdges.length == 1
			next_node = node.getDataflowEdges[0].getToNode
			if next_node != nil and not $query_blob_visited_nodes.include?next_node.getIndex and next_node.isQuery?
				$query_blob_visited_nodes.push(next_node.getIndex)
				#puts $query_blob_visited_nodes.join(" ")
				query_blob.insert(0, next_node)
				node = next_node
			else
				continue = false
			end
		else
			continue = false
		end
	end
	return query_blob
end

def find_backward_query_functions(node, query_blob)
	continue = true
	while continue
		if node.getBackwardEdges.length == 1
			prev_node = node.getBackwardEdges[0].getFromNode
			if prev_node != nil and not $query_blob_visited_nodes.include?prev_node.getIndex and prev_node.isQuery?
				$query_blob_visited_nodes.push(prev_node.getIndex)
				#puts $query_blob_visited_nodes.join(" ")
				query_blob.push(prev_node)
				node = prev_node
			else
				continue = false
			end
		else
			continue = false
		end
	end
	return query_blob
end

def find_query_blob(node)
	if not $query_blob_visited_nodes.include?node.getIndex
		$query_blob_visited_nodes.push(node.getIndex)
		#puts $query_blob_visited_nodes.join(" ")
		query_blob = [node]
		query_blob = find_forward_query_functions(node, query_blob)
		query_blob = find_backward_query_functions(node, query_blob)
		$query_stmts.push(query_blob)
	end
end

def find_all_query_blobs
	$query_blob_visited_nodes = []
	$query_stmts = []
	$node_list.each do |n|
		if n.isQuery? and not $query_blob_visited_nodes.include?n
			find_query_blob(n)
		end
	end

	info_file = File.open("#{$app_dir}/querySinksAnalysis.xml", "a")
	$query_stmts.each do |stmt|
		content = ""
		stmt.each do |n|
			content += get_xml("instruction", n.getInstr.toString, attributes: [["node_index", n.getIndex.to_s]], escape_content: true)
		end

		start_node = stmt[0]
		end_node = stmt[stmt.length - 1]
		if start_node.getBackwardEdges.length > 0
			start_node.getBackwardEdges.each do |edge|
				prev_node = edge.getFromNode
				if prev_node != nil
					content = get_xml("prev_instruction", prev_node.getInstr.toString, attributes: [["node_index", prev_node.getIndex.to_s]], escape_content: true) + content
				end
			end
		end
		if end_node.getDataflowEdges.length > 0
			end_node.getDataflowEdges.each do |edge|
				next_node = edge.getToNode
				if next_node != nil
					content += get_xml("next_instruction", next_node.getInstr.toString, attributes: [["node_index", next_node.getIndex.to_s]], escape_content:true)
				end
			end
		end
		info_file.puts get_xml("query", content, attributes:[["inst_count", stmt.length.to_s]])
	end
	info_file.close
end

def find_interesting_nodes
	content =""
	count = 0
	$node_list.each do |n|
		if n.getInstr.instance_of?AttrAssign_instr
			node_content = ""
			if n.getBackwardEdges.length == 1
				prev_node = n.getBackwardEdges[0].getFromNode

				if prev_node != nil and prev_node.isQuery?
					count += 1
					node_content = trace_data_dependency_till_sink(n, n, 0, [], is_root:true)
					# node_content += get_xml("instruction", n.getInstr.toString, attributes: [["node_index", n.getIndex.to_s]], escape_content: true)
					# count += 1
					# next_nodes_content = ""
					# n.getDataflowEdges.each do |edge|
					# 	next_node = edge.getToNode
					# 	next_nodes_content += get_xml("instruction", next_node.getInstr.toString, attributes: [["node_index", next_node.getIndex.to_s]], escape_content: true)
					# end
					# node_content += get_xml("forward_edges", next_nodes_content, attributes: [["count", n.getDataflowEdges.length]])
				end
				content += get_xml("assign", node_content)
			end
		end
	end

	if(content != "")
		info_file = File.open("#{$app_dir}/querySinksAnalysis.xml", "a")
		info_file.puts get_xml("action", content, attributes:[["class", $start_class.to_s], ["function", $start_function.to_s], ["count", count.to_s]])
		info_file.close
	end
end

def find_interesting_nodes_old
  $queries_and_sinks = Hash.new
  content = ""
  count = 0

	$node_list.each do |n|
		if n.isQuery?
			if n.getBackwardEdges.length == 1 and n.getBackwardEdges[0].getFromNode.isQuery?
				#ignore the exploration here
			else
	      $queries_and_sinks.clear
	      content += trace_data_dependency_till_sink(n, n, 0, [], is_root:true)
	      count += 1
			end
		end
	end

	if(content != "")
		info_file = File.open("#{$app_dir}/querySinksAnalysis.xml", "a")
		analysis_content = get_xml("queries", content, attributes: [["count", count.to_s]])
		info_file.puts get_xml("action", analysis_content, attributes:[["class", $start_class.to_s], ["function", $start_function.to_s]])
		info_file.close
	end
end

def trace_data_dependency_till_sink(root_node, node, distance, visited_nodes, as_node:true, is_root: false)
  node_index = node.getIndex
  instruction_content = node.getInstr.toString
	node_content = get_xml("instruction", instruction_content.to_s, attributes: [["node_index", node.getIndex.to_s]], escape_content: true)
  is_query = node.isQuery?

  #check if the node is a query and explore children only if root
  explore = true
  if is_query
    explore = false
    if is_root
      explore = true
    end
  end

  sink = false
  if explore
    children_count = node.getDataflowEdges.length
		# if children_count == 1 and node.getDataflowEdges[0].getToNode.isQuery?
		# 	#identify stacked up query functions
		# 	visited_nodes.push(node.getIndex)
		# 	to_node = node.getDataflowEdges[0].getToNode
		# 	node_content += trace_data_dependency_till_sink(root_node, to_node, distance, visited_nodes, as_node: false)
		# 	visited_nodes.delete(node.getIndex)
		# 	sink = false
    if children_count > 0 and not visited_nodes.include?(node.getIndex)
			#traverse overall graph, if not a stacked up query function
      children_content = ""
      visited_nodes.push(node.getIndex)
      node.getDataflowEdges.each do |edge|
        child_node = edge.getToNode
        if child_node != nil
          children_content += trace_data_dependency_till_sink(root_node, child_node, distance + 1, visited_nodes)
        end
      end
      node_content += get_xml("children", children_content, attributes: [["count", children_count]])
      visited_nodes.delete(node.getIndex)
    elsif children_count == 0 and not visited_nodes.include?(node.getIndex)
      sink = true
    end
  else
    sink = true
  end

  # if sink and root_node.getIndex != node.getIndex
  #   if $queries_and_sinks.has_key?root_node
	# 		$queries_and_sinks[root_node] << node
	# 	else
	# 		$queries_and_sinks[root_node] = [node]
	# 	end
  # end

	if as_node
	  if is_root
	    #node_content += get_sinks_as_xml(root_node)
	    return get_xml("query", node_content.to_s, attributes: [["distance", distance.to_s]])
	  else
	    return get_xml("node", node_content.to_s, attributes: [["distance", distance.to_s]])
	  end
	else
		return node_content.to_s
	end
end

def compute_query_only_used_for_queries
	count = 0
	loop_count = 0
	content = ""
	$node_list.each do |n|
		is_in_loop = false
		if n.isReadQuery?
			qn_list = traceforward_data_dep(n)
			only_to_query = true
			ignore = false

			if n.getDataflowEdges.length == 1 and n.getDataflowEdges[0].getFromNode.getInstr.isQuery
				#remove the cases like C.where().group(), so C.where() will not be considered
				ignore = true
			end

			qn_list.each do |n1|
				if n1.isQuery?
					only_to_query = true
				end

				if n1.getDataflowEdges.length == 0
					if n1.isBranch? or n1.getInView or isValidationSink(n1) or isCacheSink(n1)
						only_to_query = false
					end
					if sinkIgnore(n1) == false
						ignore = true
					end
				end
			end

			if not ignore and only_to_query
				if n.getNonViewClosureStack.length > 0
					is_in_loop = true
					loop_count += 1
				end
				count += 1
				content += get_xml("instruction", n.getInstr.toString, attributes:[["index", n.getIndex], ["in_loop", is_in_loop.to_s]], escape_content:true)
			end
		end
	end

	if(content != "")
		info_file = File.open("#{$app_dir}/querySinksAnalysis.xml", "a")
		info_file.puts get_xml("action", content, attributes:[["class", $start_class.to_s], ["function", $start_function.to_s], ["count", count.to_s], ["loop_count", loop_count.to_s]])
		info_file.close
	end
end

def get_app_name_from_dir(app_dir)
	words = app_dir.split("/")
	return words[words.length - 1]
end

def post_process_query_sinks_analysis
	content = File.read("#{$app_dir}/querySinksAnalysis.xml")
	File.delete("#{$app_dir}/querySinksAnalysis.xml")
	app_name = get_app_name_from_dir($app_dir)
	info_file = File.open("querySinkResults/#{app_name}.xml", "w")
	info_file.puts get_xml("app", content)
	info_file.close
end
