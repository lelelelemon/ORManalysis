$dataflow_files = "./lobsters/dataflow/*.log"

class Data_dependency
	def initialize(block, instr, vname)
		@block = block
		@instr = instr
		@vname = vname
		@instr_handler = nil
	end
	def setInstrHandler(h)
		@instr_handler = h
	end
	def getInstrHandler
		@instr_handler
	end
	def getBlock
		@block
	end
	def getInstr
		@instr
	end
	def getVname
		@vname
	end
	def equals(d)
		if d.getBlock == @block and d.getInstr == @instr and d.getVname == @vname
			return true
		else
			return false
		end
	end
end

class Instruction
	def initialize
		@deps = Array.new	
		@resolved = false
		@has_closure = false
		@closure = nil
		@index = 0
		@f_tag = 0
		@bb = nil
		@inode = nil
	end
	def setINode(i)
		@inode = i
	end
	def getINode
		@inode
	end
	def setBB(_bb)
		@bb = _bb
	end
	def getBB
		@bb
	end
	def setFTag(f)
		@f_tag = f
	end
	def getFTag
		@f_tag
	end
	def addClosure(cl)
		@closure = cl
		@has_closure = true
	end
	def hasClosure?
		@has_closure
	end
	def getClosure
		@closure
	end
	def setIndex(ind)
		@index = ind
	end
	def getIndex
		@index
	end
	def addDatadep(dep_string, vname, handler = nil)
		ary = dep_string.split('.')
		dep = Data_dependency.new(ary[0].to_i, ary[1].to_i, vname)
		if handler != nil
			dep.setInstrHandler(handler)
		end
		exist = false
		@deps.each do |d|
			if d.equals(dep)
				exist = true
			end
		end
		if exist == false
			@deps.push(dep)
		end
	end
	def getDeps
		@deps
	end
	def isResolved?
		@resolved
	end
	def setResolved
		@resolved = true
	end
	def toString
		s = ""
		@deps.each do |dep|
			s = s + "#{dep.getVname}[#{dep.getBlock}.#{dep.getInstr}] "
		end
		return s
	end
end

class Call_instr < Instruction
	def initialize(_caller, _funcname)
		@deps = Array.new	
		@resolved = false
		@caller = _caller;
		@funcname = _funcname	
		@resolved_caller = ""
		@call_handler = nil
	end
	def setCallHandler(h)
		@call_handler = h
	end
	def getCallHandler
		@call_handler
	end
	def getCaller
		@caller
	end
	def getFuncname
		@funcname
	end
	def setResolvedCaller(_caller)
		@resolved_caller = _caller
		@resolved = true
	end
	def getResolvedCaller
		@resolved_caller
	end
	def getResolvedString
		s = "#{@resolved_caller}.#{@funcname}"
		return s
	end
	def toString
#		s = "#{@caller}->#{@funcname} "
#		s = s + super
		s = "#{@resolved_caller} -> #{@funcname}"
		return s
	end
end

class Const_instr < Instruction
	def initialize(const)
		@const = const
		@deps = Array.new	
		@resolved = false
	end
	def getConst
		@const
	end
	def getResolvedString
		@const
	end
	def toString
		s = "(#{@const})"
		return s
	end
end

class Return_instr < Instruction
	def initialize
		super
	end
	def toString
		s = "RETURN "
		s = s + super
		return s
	end
end

class Branch_instr < Instruction
	def initialize
		super
	end
	def toString
		s = "BRANCH "
		s = s + super
		return s
	end
end

class Basic_block
	def initialize(index)
		@outgoings = Array.new
		@datadeps = Array.new
		@instructions = Array.new
		@calls = Array.new
		@index = index.to_i
		@label_n = 0
		@cfg = nil
		@return_list = Array.new
	end
	def addReturn(r)
		@return_list.push(r)
	end
	def getReturns
		@return_list
	end	
	def addCFG(cfg)
		@cfg = cfg
	end
	def getCFG
		@cfg
	end
	def addInstr(instr)
		@instructions.push(instr)
		instr.setBB(self)
	end
	def getInstr
		@instructions
	end
	def getLastInstr
		@instructions[-1]
	end
	def addOutgoings(node)
		@outgoings.push(node)
	end
	def getOutgoings
		@outgoings
	end
	def getIndex
		@index
	end
	def addDatadeps(dep)
		@datadeps.push(dep)
	end
	def setLabelN(n)
		@label_n = n
	end
	def getLabelN
		@label_n
	end
	def searchDepLocally(instr, var=nil)
		instr.getDeps.each do |dep|
			if dep.getBlock == @index #locally, blockID matches
				if var != nil
					if var == dep.getVname
						return @instructions[dep.getInstr]
					end
				else
					return @instructions[dep.getInstr]
				end
			end
		end	
		return nil
	end
	def findCalls
		@instructions.each do |instr|
			if instr.instance_of?Call_instr
				#caller = self
				if instr.getCaller=="%self"
					instr.setResolvedCaller("self")
	
				else
					caller_v = instr.getCaller
					dep_instr = searchDepLocally(instr, caller_v)
					if dep_instr != nil and dep_instr.isResolved?
						instr.setResolvedCaller(dep_instr.getResolvedString)
					elsif instr.getCaller.include?('%')==false
						instr.setResolvedCaller(instr.getCaller)
					end
				end
			elsif instr.instance_of?Const_instr
				instr.setResolved
			end
			if instr.hasClosure?
				instr.getClosure.getBB.each do |bb|
					bb.findCalls
				end
			end
		end
	end
	def self_print
		puts "BB #{@index}"
		print "  outgoing:"
		s = ""
		@outgoings.each do |og|
			s = s + "#{og} "
		end
		puts "#{s}"
		puts "  instructions:"
		index = 0
		@instructions.each do |instr|
			puts "    #{index}: #{instr.toString}"
			if instr.hasClosure?
				instr.getClosure.self_print
			end
			index = index + 1
		end
	end
end

class CFG
	def initialize
		@bb = Array.new
		@return_list = Array.new
	end
	def addReturn(r)
		@return_list.push(r)
	end
	def getReturns
		@return_list
	end
	def getBB
		@bb
	end
	def addBB(basicb)
		@bb.push(basicb)
		basicb.addCFG(self)
	end
	def findCalls
		getBB.each do |bb|
			bb.findCalls
		end	
	end
	def getBBByIndex(i)
		@bb.each do |b|
			if b.getIndex == i
				return b
			end
		end
		return nil
	end
end

class Closure < CFG
	def initialize
		super
	end
	def getLastBB
		return @bb[-1]
	end
	def getFirstBB
		return @bb[0]
	end
	def self_print
		puts "CLOSURE BEGIN"
		getBB.each do |bb|
			bb.self_print
		end
		puts "CLOSURE END"
	end
end

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

	$dataflow_files = "#{$app_dir}/dataflow/controllers/*.log"

	Dir.glob($dataflow_files) do |item|
		next if item == '.' or item == '..'
		class_name = get_mvc_name2(item)
		handle_single_dataflow_file(item, class_name)
		$class_map[class_name].getMethods.each do |key, meth|
			if meth.getCFG != nil
				meth.getCFG.findCalls
			end
		end
	end

	$dataflow_files = "#{$app_dir}/dataflow/models/*.log"

	Dir.glob($dataflow_files) do |item|
		next if item == '.' or item == '..'
		class_name = get_mvc_name2(item)
		handle_single_dataflow_file(item, class_name)
		$class_map[class_name].getMethods.each do |key, meth|
			if meth.getCFG != nil
				meth.getCFG.findCalls
			end	
		end
	end
end

def find_method(class_name, method_name)
	puts "class_name = #{class_name}, method_name = #{method_name}"
	return ($class_map[class_name].getMethods)[method_name]	
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
				m.setCFG($cur_cfg)

			elsif line.include?("JRUBY")
				nil
			elsif line.include?("CLOSURE BEGIN")
				$cur_bb_stack.push($cur_bb)
				$cur_cfg_stack.push($cur_cfg)
				$cur_cfg = Closure.new
				
			elsif line.include?("CLOSURE END")
				#$cur_cfg.getLastBB.addOutgoings($cur_cfg.getFirstBB.getIndex)
				$cur_bb = $cur_bb_stack[-1]
				$cur_bb.getLastInstr.addClosure($cur_cfg)
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
										cur_instr = Call_instr.new(fc_array[0], fc_array[1])
										
									elsif single_attr.include?('[') and single_attr.include?(']')
										bracket_begin = single_attr.index('[')
										bracket_end = single_attr.index(']')
										dep_string = single_attr[bracket_begin+1...bracket_end-1]
										deps = dep_string.split(',')
										v_name = single_attr[0...bracket_begin]
										deps.each do |dep|
											if dep.length > 0
												dep_str = dep.split('.')
												#dep_instr = nil
												#if $cur_cfg.getBBByIndex(dep_str[0].to_i) != nil
												#	$cur_cfg.getBBByIndex(dep_str[0].to_i).getInstr[dep_str[1].to_i]
												#else
												#	puts "block #{dep_str[0].to_i}  doesn't exist"
												#end
												#if dep_instr != nil
												cur_instr.addDatadep(dep, v_name)
												#else
												#	puts "DEP instructions cannot be found: #{dep_str[0].to_i}.#{dep_str[1].to_i}"
												#end
											end
										end

									elsif single_attr == "RETURN"
										cur_instr = Return_instr.new

									elsif single_attr.include?('(') and single_attr.include?(')')
										bracket_begin = single_attr.index('(')
										bracket_end = single_attr.index(')')
										cur_instr = Const_instr.new(single_attr[bracket_begin+1...bracket_end])
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
				dep_instr = cfg.getBBByIndex(d.getBlock.to_i).getInstr[d.getInstr.to_i]
				if dep_instr != nil
					d.setInstrHandler(dep_instr)
				else
					puts "DEP instr nil: #{keyc}.#{key}: BB#{d.getBlock.to_i}.#{d.getInstr.to_i}"
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
