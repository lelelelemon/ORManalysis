$dataflow_files = "./lobsters/dataflow/*.log"

class Data_dependency
	def initialize(block, instr, vname)
		@block = block
		@instr = instr
		@vname = vname
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
end

class Instruction
	def initialize
		@deps = Array.new	
		@resolved = false
	end
	def addDatadep(dep_string, vname)
		ary = dep_string.split('.')
		dep = Data_dependency.new(ary[0].to_i, ary[1].to_i, vname)
		@deps.push(dep)
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

class Basic_block
	def initialize(index)
		@outgoings = Array.new
		@datadeps = Array.new
		@instructions = Array.new
		@calls = Array.new
		@index = index.to_i
		@label_n = 0
	end
	def addInstr(instr)
		@instructions.push(instr)
	end
	def getInstr
		@instructions
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
	def setLableN(n)
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
			index = index + 1
		end
	end
end

class CFG
	def initialize
		@bb = Array.new
	end
	def getBB
		@bb
	end
	def addBB(basicb)
		@bb.push(basicb)
	end
end

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
				meth.getCFG.getBB.each do |bb|
					bb.findCalls
				end	
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
				meth.getCFG.getBB.each do |bb|
					bb.findCalls
				end
			end	
		end
	end
end

def find_method(class_name, method_name)
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
												cur_instr.addDatadep(dep, v_name)
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
							$cur_bb.addInstr(cur_instr)	
						end
					end
				end
			end
		end
end

def retrive_calls
	$cfg_map.each do |keyc, valuec|
		valuec.getBB.each do |bb|
			bb.findCalls
		end
	end	
end


#read_dataflow
#retrive_calls

#$cfg_map.each do |keyc, valuec|
#	puts "SET IRMethod, name = #{keyc}"
#	valuec.getBB.each do |bb|
#		bb.self_print
#	end
#end
