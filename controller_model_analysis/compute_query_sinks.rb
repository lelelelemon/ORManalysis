require 'active_support/core_ext/string'
def analyse_query_sinks
	find_interesting_nodes
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

def find_interesting_nodes
  $queries_and_sinks = Hash.new
  content = ""
  count = 0
	$node_list.each do |n|
		if n.isQuery?
      $queries_and_sinks.clear
      content += trace_data_dependency_till_sink(n, n, 0, [], is_root:true)
      count += 1
		end
	end

	if(content != "")
		info_file = File.open("#{$app_dir}/querySinksAnalysis.xml", "a")
		analysis_content = get_xml("queries", content, attributes: [["count", count.to_s]])
		info_file.puts get_xml("action", analysis_content, attributes:[["class", $start_class.to_s], ["function", $start_function.to_s]])
		info_file.close
	end
end

def trace_data_dependency_till_sink(root_node, node, distance, visited_nodes, is_root: false)
  node_index = node.getIndex
  instruction_content = node.getInstr.toString
	node_content = get_xml("instruction", instruction_content.to_s, escape_content: true)
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
    if children_count > 0 and \
      not visited_nodes.include?(node.getIndex)
      children_content = ""
      visited_nodes.push(node.getIndex)
      node.getDataflowEdges.each do |edge|
        child_node = edge.getToNode
        if child_node != nil
          children_content += trace_data_dependency_till_sink(root_node, child_node, distance + 1, visited_nodes)
        end
      end
      #node_content += get_xml("children", children_content, attributes: [["count", children_count]])
      visited_nodes.delete(node.getIndex)
    elsif children_count == 0 and not visited_nodes.include?(node.getIndex)
      sink = true
    end
  else
    sink = true
  end

  if sink and root_node.getIndex != node.getIndex
    if $queries_and_sinks.has_key?root_node
			$queries_and_sinks[root_node] << node
		else
			$queries_and_sinks[root_node] = [node]
		end
  end

  if is_root
    node_content += get_sinks_as_xml(root_node)
    return get_xml("query", node_content.to_s, attributes: [["index", node.getIndex.to_s], ["distance", distance.to_s]])
  else
    return get_xml("node", node_content.to_s, attributes: [["index", node.getIndex.to_s], ["distance", distance.to_s]])
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
