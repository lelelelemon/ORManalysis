$query_in_view = 0
$query_in_controller = 0
$query_in_model = 0
$query_in_other = 0
def calculate_query_issue_stat(cfg, class_instance)
	if cfg 
		cfg.getBB.each do |bb|
			bb.getInstr.each do |instr|
				if instr.hasClosure?
					calculate_query_issue_stat(instr.getClosure, class_instance)
				end
				if instr.isQuery
					if class_instance.class_type == "controller"
						if instr.in_view
							puts "Query in view: #{instr.toString}"
							$query_in_view += 1
						else
							$query_in_controller += 1
						end
					elsif class_instance.class_type == "model"
						$query_in_model += 1
					else
						$query_in_other += 1
					end
				end
			end
		end
	end

end
