
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
		@from_user_input = false
		@index = 0
		@f_tag = 0
		@bb = nil
		@inode = nil
	end
	def setFromUserInput
		@from_user_input = true
	end
	def getFromUserInput
		@from_user_input
	end
	def getToUserOutput
		if @bb.getCFG.instance_of?Closure
			@bb.getCFG.getViewCode
		else
			return false
		end
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
		if dep_string == ""
			#no explicit def is found in the closure
			dep = Data_dependency.new(-1, -1, vname)
			if handler != nil
				#puts "#{vname} is defined by #{handler.toString}"
				dep.setInstrHandler(handler)
			end
			@deps.push(dep)
			return
		end
		ary = dep_string.split('.')
		dep = Data_dependency.new(ary[0].to_i, ary[1].to_i, vname)
		#if handler == nil, the dep will be handled in calculate_depinstr_for_cfg in read_dataflow.rb
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
		s = " (#{@bb.getIndex}.#{@index}) "
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
	def isQuery
		if @call_handler != nil
			return @call_handler.isQuery
		else
			return false
		end
	end
	def getCaller
		@caller
	end
	def getFuncname
		@funcname
	end
	def setFuncname(f)
		@funcname = f
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
		s = super
		s = s + " #{@resolved_caller} -> #{@funcname}"
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
		@explicit_return = Array.new
	end
	def addExplicitReturn(r)
		@explicit_return.push(r)
	end
	def getExplicitReturn
		@explicit_return
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
		#return_list is the return point in control flow, including both "RETURN" instr and exit point in CFG
		@return_list = Array.new
		#explicit_return is the return point in data flow, only include "RETURN" instr
		@explicit_return = Array.new
		@m_handler = nil
	end
	def setMHandler(m)
		@m_handler = m
	end
	def getMHandler
		@m_handler
	end
	def addExplicitReturn(r)
		@explicit_return.push(r)
	end
	def getExplicitReturn
		@explicit_return
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
		r = Random.new
		@rnd = r.rand(1...1048576)
		@view_code = false
		@view_closure = false
		@var_def_table = Array.new 
		super
	end
	def setViewClosure
	  @view_closure = true
	end
	def getViewClosure
	   @view_closure
	end
	def addToVarDefTable(vname, dep, handler)	
		ary = dep.split('.')
		dep = Data_dependency.new(ary[0].to_i, ary[1].to_i, vname)
		dep.setInstrHandler(handler)
		@var_def_table.push(dep)
	end
	def getVarDefs(vname)
		r = Array.new
		@var_def_table.each do |v|
			if v.getVname == vname
				r.push(v)
			end
		end
		return r
	end
	def getRand
		@rnd
	end
	def setViewCode
		@view_code = true
	end
	def getViewCode
		@view_code
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
