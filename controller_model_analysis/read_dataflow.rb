$dataflow_files = "./lobsters/dataflow/*.log"

#Indicate the rendered code replaced by view ruby code
$view_ruby_code = false
$view_closure = false

$cur_bb_stack = Array.new
$cur_cfg_stack = Array.new

$cur_cfg = nil
$cfg_map = Hash.new
$cur_bb = nil

def find_first_nonempty_ele(attrs)
	index = 0
	attrs.each do |attr|
		if attr.length > 0
			return index
		end
		index += 1
	end
	return -1	
end

def read_dataflow(application_dir=nil)

	if application_dir != nil
		$app_dir = application_dir
	end

	$dataflow_dir = "#{$app_dir}/dataflow/"

	root, files, dirs = os_walk($dataflow_dir)
	for filename in files
		if filename.to_s.end_with?(".log") and filename.to_s.include?("schema.log") == false
			class_name = dataflow_filename_match(filename.to_s) 
			if class_name != nil
				handle_single_dataflow_file(filename.to_s, class_name)
				$class_map[class_name].getMethods.each do |key, meth|
					if meth.getCFG != nil
						meth.getCFG.findCalls
					end
				end
			else
				#puts "Dataflow file #{filename} cannot find a class!"
			end
		end
	end
	
	#Dir.glob($dataflow_files) do |item|
	#	next if item == '.' or item == '..'
	#	class_name = get_mvc_name2(item)
	#	handle_single_dataflow_file(item, class_name)
	#	$class_map[class_name].getMethods.each do |key, meth|
	#		if meth.getCFG != nil
	#			meth.getCFG.findCalls
	#		end
	#	end
	#end

	#$dataflow_files = "#{$app_dir}/dataflow/models/*.log"

	#Dir.glob($dataflow_files) do |item|
	#	next if item == '.' or item == '..'
	#	class_name = get_mvc_name2(item)
	#	handle_single_dataflow_file(item, class_name)
	#	$class_map[class_name].getMethods.each do |key, meth|
	#		if meth.getCFG != nil
	#			meth.getCFG.findCalls
	#		end	
	#	end
	#end
end

def find_method(class_name, method_name)
	return $class_map[class_name].getMethod(method_name)
end


def handle_single_dataflow_file(item, class_name)
		file = File.open(item, "r")
		file.each_line do |line|
			if line.include?("SET IRMethod")
				i = line.index(" = ")
				func_name = line[i+3...line.length-1]
				$cur_cfg = CFG.new
				#$cfg_map[func_name] = $cur_cfg
				m = find_method(class_name, func_name)
				if m == nil
					#puts "Function not found: #{class_name} . #{func_name}"
					#exit
				else
						m.setCFG($cur_cfg)
				end

			elsif line.include?("JRUBY")
				nil
			elsif line.include?("CLOSURE BEGIN:")
				$cur_bb_stack.push($cur_bb)
				$cur_cfg_stack.push($cur_cfg)
				temp_cfg = $cur_cfg
				$cur_cfg = Closure.new
				if $view_ruby_code or (temp_cfg.instance_of?Closure and temp_cfg.getViewCode)
					if $view_closure
					  $cur_cfg.setViewClosure
					  $view_closure = false
					end
				end
	
				#Variable def table
				#Handled separately because the def stmt are not in the same closure
				attrs = line.split(" ")
				index = 0	
				attrs.each do |single_attr|
					if index > 1 #Avoid handling 'CLOSURE' 'BEGIN:' 
						bracket_begin = single_attr.index('[')
						bracket_end = single_attr.index(']')
						dep_string = single_attr[bracket_begin+1...bracket_end-1]
						deps = dep_string.split(',')
						v_name = single_attr[0...bracket_begin]
						deps.each do |dep|
							if dep.length > 0
								#find instr handler here
								dep_str = dep.split('.')
								if temp_cfg.getBBByIndex(dep_str[0].to_i) == nil
									#TODO: ignore loop dependency here....
									#puts "LINE: #{line}"
								else
									dep_instr = temp_cfg.getBBByIndex(dep_str[0].to_i).getInstr[dep_str[1].to_i]
									#puts "READ DATAFLOW: add to var table: #{v_name} (#{dep_instr.toString})"
									$cur_cfg.addToVarDefTable(v_name, dep, dep_instr)
								end
							end
						end
					end
					index = index + 1
				end
			elsif line.include?("CLOSURE END")
				#$cur_cfg.getLastBB.addOutgoings($cur_cfg.getFirstBB.getIndex)
				$cur_bb = $cur_bb_stack[-1]
				$cur_bb.getLastInstr.addClosure($cur_cfg)
				if $cur_cfg.getViewClosure
				  $view_ruby_code = false
				end
				attrs = line.split(" ")
				index = 0	
				attrs.each do |single_attr|
					if index > 1 #Avoid handling 'CLOSURE' 'BEGIN:' 
						bracket_begin = single_attr.index('[')
						bracket_end = single_attr.index(']')
						dep_string = single_attr[bracket_begin+1...bracket_end-1]
						deps = dep_string.split(',')
						v_name = single_attr[0...bracket_begin]
						deps.each do |dep|
							if dep.length > 0
								#find instr handler here
								dep_str = dep.split('.')
								dep_instr = $cur_cfg.getBBByIndex(dep_str[0].to_i).getInstr[dep_str[1].to_i]
								#puts "READ DATAFLOW: add to var table: #{v_name} (#{dep_instr.toString})"
								$cur_cfg.addToClosureDefTable(v_name, dep, dep_instr)
							end
						end
					end
					index = index + 1
				end

				$cur_cfg = $cur_cfg_stack[-1]
				$cur_bb_stack.pop
				$cur_cfg_stack.pop
			elsif line.include?("BB ")
				$cur_bb = Basic_block.new(line.split(' ')[1].to_s)
				$cur_cfg.addBB($cur_bb)
			else
				attrs = line.split(" ")
				i = find_first_nonempty_ele(attrs)
				if i!= -1
					attr = attrs[i]
					if attr[-1,1] == ':'
						if attr.include?("outgoing")
							index = 0
							attrs.each do |single_attr|
								if index > i
									$cur_bb.addOutgoings(single_attr.to_i)	
								end
								index += 1
							end
						elsif attr.include?("datadep")
							index = 0
							attrs.each do |single_attr|
								if index > i
									$cur_bb.addDatadeps(single_attr.to_i)	
								end
								index += 1
							end
						elsif attr.include?("instructions")
						else
							#instruction number
							index = 0
							cur_instr = Instruction.new
							attrs.each do |single_attr|
								if index > i
									if single_attr.include?("->")
										fc_array = single_attr.split("->")
										#fc_array[0]: caller
										#fc_array[1]: function_name
										if cur_instr.instance_of?AttrAssign_instr
											cur_instr = AttrAssign_instr.new(fc_array[0], fc_array[1])
										elsif cur_instr.instance_of?GetField_instr
											cur_instr = GetField_instr.new(fc_array[0], fc_array[1])
										else
											cur_instr = Call_instr.new(fc_array[0], fc_array[1])
										end
										#TODO: previous instr may not be dataflow dependent instr...
										if $cur_bb.getInstr.length > 0 and $cur_bb.getInstr[-1].instance_of?HashField_instr and cur_instr.instance_of?Call_instr
											prev_instr = $cur_bb.getInstr[-1]
											prev_instr.hash_fields.each do |h|
												cur_instr.hash_fields.push(h)
											end
										end
										if cur_instr.getCaller.include?("self") and ["params","session","cookies"].include?cur_instr.getFuncname
												cur_instr.setFromUserInput
										end
										if cur_instr.getFuncname == "ruby_code_from_view"
												$view_ruby_code = true
												$view_closure = true
										end
									elsif single_attr.include?("ARGS:")
										args = single_attr[5...-1].split(',')
										args.each do |a|
											cur_instr.getArgs.push(a)
										end	
									elsif single_attr.include?('[') and single_attr.include?(']')
										bracket_begin = single_attr.index('[')
										bracket_end = single_attr.index(']')
										#no explicit define is found, for named vairables like @message
											if $cur_cfg.instance_of?Closure
												v_name = single_attr[0...bracket_begin]
												#puts "Find use without def: #{v_name} (#{$cur_bb.getIndex}.#{$cur_bb.getInstr.length})"
												$cur_cfg.getVarDefs(v_name).each do |v|
													cur_instr.addDatadep("", v_name, v.getInstrHandler)
													#puts "\t\thandler: #{v.getInstrHandler.toString}"
												end
											end
										
										if bracket_begin == bracket_end - 1 
										else
											dep_string = single_attr[bracket_begin+1...bracket_end-1]
											deps = dep_string.split(',')
											v_name = single_attr[0...bracket_begin]
											deps.each do |dep|
												if dep.length > 0
													#dep_str = dep.split('.')
													#dep_instr = nil
													#if $cur_cfg.getBBByIndex(dep_str[0].to_i) != nil
													#	$cur_cfg.getBBByIndex(dep_str[0].to_i).getInstr[dep_str[1].to_i]
													#else
													#	puts "block #{dep_str[0].to_i}  doesn't exist"
													#end
													#if dep_instr != nil
													#XXX:Here is some non-beautiful trick, attrassign don't use the class instance, it only assigns. So avoid defining the use of class instance
													#if cur_instr.instance_of?AttrAssign_instr
														#if v_name.include?('%')==true
															cur_instr.addDatadep(dep, v_name)
														#end
													#else
														#cur_instr.addDatadep(dep, v_name)
													#end
													#else
													#	puts "DEP instructions cannot be found: #{dep_str[0].to_i}.#{dep_str[1].to_i}"
													#end
												end
											end
										end
					
									elsif single_attr.index("def_") == 0
										single_attr.gsub('def_', '')
										cur_instr.setDefv(single_attr.gsub('def_',''))

									elsif single_attr.index("TYPE_") == 0 and cur_instr.instance_of?Copy_instr
										cur_instr.type = single_attr.gsub('TYPE_','')

									elsif single_attr == "RETURN"
										cur_instr = Return_instr.new
									
									elsif single_attr == "BRANCH"
										cur_instr = Branch_instr.new
				
									elsif single_attr == "BUILDSTRING"
										cur_instr = BuildString_instr.new

									elsif single_attr == "RECEIVEARG"
										cur_instr = ReceiveArg_instr.new
	
									elsif single_attr == "ATTRASSIGN"
										cur_instr = AttrAssign_instr.new("", "")

									elsif single_attr == "GETFIELD"
										cur_instr = GetField_instr.new("", "")								
	
									elsif single_attr == "COPY"
										cur_instr = Copy_instr.new	

									elsif single_attr.include?("HASH")
										cur_instr = HashField_instr.new
										fields = single_attr.split('-')
										for i in 1...fields.length do
											h_k = fields[i]
											if h_k.length > 0
												cur_instr.addHash(h_k)
											end
										end
	
									elsif single_attr.include?('(') and single_attr.include?(')')
										bracket_begin = single_attr.index('(')
										bracket_end = single_attr.index(')')
										if single_attr.include?("inherit ") and $cur_bb.getInstr[-1].is_a?Const_instr
												upper_name = $cur_bb.getInstr[-1].getConst
												cur_name = single_attr[bracket_begin+1...bracket_end].gsub('inherit ','')	
												cur_instr = InheritConst_instr.new("#{upper_name}::#{cur_name}") 
										else
											cur_instr = Const_instr.new(single_attr[bracket_begin+1...bracket_end])
										end
									end
								end
								index += 1
							end
							cur_instr.setIndex($cur_bb.getInstr.length)
							$cur_bb.addInstr(cur_instr)	
						end
					end
				end
			end
		end

		$class_map.each do |keyc, valuec|
			valuec.getMethods.each do |key, value|
				cfg = value.getCFG
				if cfg != nil
					calculate_depinstr_for_cfg(cfg)
				end
			end
		end	
end

def calculate_depinstr_for_cfg(cfg)
	
	cfg.getBB.each do |bb|
		#puts "\tBB#{bb.getIndex}:"
		bb.getInstr.each do |instr|
			#print "\t\tinstr: #{instr.toString}"
			instr.getDeps.each do |d|
				#print "#{d.getBlock}.#{d.getInstr}, "
				dep_instr = d.getInstrHandler
				if d.getBlock == -1 and d.getInstr == -1
					#no explicit define, look for cfg var table
					#if dep_instr != nil
					#	puts "No explicit def, handler = #{dep_instr.toString}"
					#else
					#	puts "No explicit def, handler = nil"
					#end
				else
					dep_instr = cfg.getBBByIndex(d.getBlock.to_i).getInstr[d.getInstr.to_i]
				end
				if dep_instr != nil
					d.setInstrHandler(dep_instr)
				else
					puts "DEP instr nil: #{cfg.getMHandler.getCallerClass.getName}.#{cfg.getMHandler.getName}: cur BB#{bb.getIndex}.#{instr.getIndex} depend on BB#{d.getBlock.to_i}.#{d.getInstr.to_i}"
				end 
			end	
			#puts ""
			if instr.hasClosure?
				calculate_depinstr_for_cfg(instr.getClosure)
			end
		end
	end
end



#read_dataflow

#$cfg_map.each do |keyc, valuec|
#	puts "SET IRMethod, name = #{keyc}"
#	valuec.getBB.each do |bb|
#		bb.self_print
#	end
#end
