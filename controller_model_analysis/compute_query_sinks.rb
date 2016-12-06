require 'active_support/core_ext/string'
def analyse_query_sinks
	compute_query_only_used_for_queries
end

def isAssign?(node)
	instr = node.getInstr
	if instr.instance_of?(AttrAssign_instr)
		return true
	elsif instr.getDefv == nil
		return false
	elsif instr.getDefv.length == 0
		return false
	elsif instr.getDefv.length > 0 and instr.getDefv.include?('%')
		return false
	end
	return true
end

def compute_query_only_used_for_queries
	count = 0
	loop_count = 0
	content = ""
	$node_list.each do |n|
		is_in_loop = false
		if isAssign?(n)
			qn_list = traceforward_data_dep(n)
			atleast_one_query = false
			only_to_query = true
			ignore = false

			if n.getDataflowEdges.length == 1 and n.getDataflowEdges[0].getToNode.getInstr.isQuery
				ignore = true
			end

			children = []
			children_content = ""
			qn_list.each do |n1|
				if n1.isQuery?
					atleast_one_query = true
					children << n1
				end

				if n1.getDataflowEdges.length == 0
					if n1.isBranch? or n1.getInView or isValidationSink(n1) or isCacheSink(n1)
						only_to_query = false
					end
				end
			end

			if not ignore and only_to_query and atleast_one_query
				if n.getNonViewClosureStack.length > 0
					is_in_loop = true
					loop_count += 1
				end
				count += 1
				node_content = get_xml("instruction", n.getInstr.toString, attributes:[["index", n.getIndex]], escape_content:true)
				children.each do |child|
						children_content += get_xml("instruction", child.getInstr.toString, attributes:[["index", child.getIndex]], escape_content:true)
				end
				node_content += get_xml("sinks", children_content)
				content += get_xml("node", node_content, attributes:[["index", n.getIndex], ["in_loop", is_in_loop.to_s]])
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
