require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'

class Variable
	def initialize(v_name, type)
		@name = v_name
		@type = type
	end
	attr_accessor :name, :type
end

class Temp_variable < Variable
	def initialize(v_name, type)
		super(v_name, type)
	end
end

class Field_variable < Variable
	def initialize(v_name, type)
		super(v_name, type)
	end
end

class Local_variable < Variable
	def initialize(v_name, type)
		super(v_name, type)
	end
end


def add_to_var_table(f_name, c_name, v_name, type)
	if $class_map[c_name].getMethod(f_name).getVars[v_name]
		_type_name = $class_map[c_name].getMethod(f_name).getVars[v_name]
		if _type_name == type
		else
			puts "TYPE doesn't match! #{v_name}: [#{_type_name}] [#{type}]"
		end
	else
		$class_map[c_name].getMethod(f_name).getVars[v_name] = type
	end
end

def add_to_cfg_varmap(cfg, c_name, v_name, type)
	var = nil
	if v_name.include?("self")
		var = Local_variable.new(v_name, c_name)
	elsif v_name.include?("%")
		var = Temp_variable.new(v_name, type)
	else
		var = Local_variable.new(v_name, type)
	end
	cfg.addToVarMap(v_name, var)
end

$unknown_types = Hash.new

def known_type(v_name, cfg, c_name)
	#first look for the cfg var_map
	var = cfg.getVarMap[v_name]
	if var == nil
		#then look for class field
		if $class_map[c_name] != nil
			var = $class_map[c_name].getVarMap[v_name]
		end
	end
	return var
end

def type_not_found(var)
	if var == nil
		return true
	elsif var.type == "unknown"
		return true
	end
	return false
end

#key:function name
#value:return value type
$util_function_list = Hash.new
def read_util_function
	f_name = "./util_func_list.txt"
	File.open(f_name, "r").each do |line|
		line = line.gsub("\n","")
		chs = line.split(' ')
		$util_function_list[chs[0]] = chs[1]
	end
end
def util_function(fname)
	return $util_function_list[fname]
end

def do_type_inference
	read_util_function
	$class_map.each do |keyc, valuec|
		@class_var_list = Hash.new
		valuec.getFields.each do |f|
			@class_var_list[f.field_name] = f.type	
		end
		puts "Class: #{keyc}"
		valuec.getAssocs.each do |_name, ary|
			ary.each do |a|
				if a.attribs["class_name"] != nil
					@class_var_list[a.name] = a.attribs["class_name"]
				elsif $class_map[a.name.singularize.capitalize] != nil
					@class_var_list[a.name] = a.name.singularize.capitalize
				end
				puts "ADD assocs: #{a.name}, #{@class_var_list[a.name]}"
			end
		end
		@class_var_list.each do |k, v|
			var = Field_variable.new(k, v)
			valuec.addToVarMap(k, var)
		end	
		valuec.getMethods.each do |key, value|
			cfg = value.getCFG
			if cfg != nil
				add_to_cfg_varmap(cfg, keyc, "%self", nil)
				set_initial_type(cfg, key, keyc)
				do_type_inference_cfg(cfg, key, keyc)
			end
		end
	end
	$class_map.each do |keyc, valuec|
		valuec.getMethods.each do |key, value|
			cfg = value.getCFG
			if cfg != nil and keyc=="Comment"
				puts "Function: #{key}"
				do_type_inference_cfg(cfg, key, keyc, true)
			end
		end
	end
end

def set_initial_type(cfg, f_name, c_name)
	cfg.getBB.each do |bb|
		#puts "\tBB#{bb.getIndex}:"
		bb.getInstr.each do |instr|
			if instr.getDefv != nil
				if cfg.getVarMap[instr.getDefv] == nil
					var = Variable.new(instr.getDefv, "unknown")	
					cfg.getVarMap[instr.getDefv] = var
				end
			end
		end
	end
end

#f_name: function_name
#c_name: class_name
$last_closure_arg = nil
def do_type_inference_cfg(cfg, f_name, c_name, print=false)
	cfg.getBB.each do |bb|
		if print
			puts "\tBB#{bb.getIndex}:"
		end
		bb.getInstr.each do |instr|
			if print
				puts "\t\tInstr: #{instr.getIndex}: #{instr.toString}"
			end
			if instr.hasClosure?
				if print
					puts "CLOSURE BEGIN:"
				end
				$last_closure_arg = known_type(instr.getDeps[0].getVname, cfg, c_name)
				do_type_inference_cfg(instr.getClosure, f_name, c_name)
				$last_closure_arg = nil
				if print
					puts "CLOSURE END"
				end
			end
			if instr.getDefv != nil and type_not_found(known_type(instr.getDefv, cfg, c_name))
				#if instr.getResolvedCaller != ""
				#	add_to_cfg_varmap(cfg, c_name, instr.getCaller, instr.getResolvedCaller)
				#end
				if instr.instance_of?Const_instr
					add_to_cfg_varmap(cfg, c_name, instr.getDefv, instr.getConst)
				elsif instr.instance_of?Copy_instr
					if instr.getDeps.length > 0
						var = known_type(instr.getDeps[0].getVname, cfg, c_name)
						#COPY des source
						#type of source known
						if type_not_found(var)==false
							add_to_cfg_varmap(cfg, c_name, instr.getDefv, var.type)
						end
					else
						add_to_cfg_varmap(cfg, c_name, instr.getDefv, "String")
					end
				elsif instr.instance_of?ReceiveArg_instr
					if $last_closure_arg == nil
						#function receive_arg
						if cfg.arg_types.length > 0
							arg_index = 0
							instr.getBB.getInstr.each do |inner_i|
								if inner_i == instr
									break
								elsif inner_i.instance_of?ReceiveArg_instr
									arg_index += 1
								end
							end
							arg_type = cfg.arg_types[arg_index]
							if type_not_found(arg_type) == false
								add_to_cfg_varmap(cfg, c_name, instr,getDefv, arg_type.type)
							end
						end	
					else
						if type_not_found($last_closure_arg)==false
							add_to_cfg_varmap(cfg, c_name, instr.getDefv, $last_closure_arg.type)
						end
					end
				#elsif instr.instance_of?GetField_instr
				#	#GETFIELD def_v field_name
				#	#If field type is known, pass the type to v
				#	if cfg.getVarMap[instr.getFuncname] != nil
				#		add_to_cfg_varmap(cfg, c_name, instr.getDefv, cfg.getVarMap[instr.getFuncname])
				#	else
				#		#puts "Field not found: #{instr.getFuncname}"
				#	end
				elsif instr.is_a?Call_instr
					caller_type = known_type(instr.getCaller, cfg, c_name)
					if type=util_function(instr.getFuncname)
						add_to_cfg_varmap(cfg, c_name, instr.getDefv, type)
					elsif type_not_found(caller_type)
					else
						#is field?
						is_field = known_type(instr.getFuncname.gsub('!','').gsub('?',''), cfg, caller_type.type)
						if type_not_found(is_field) == false
							add_to_cfg_varmap(cfg, c_name, instr.getDefv, is_field.type)
						end
						if instr.isReadQuery or ["new"].include?instr.getFuncname
							add_to_cfg_varmap(cfg, c_name, instr.getDefv, caller_type.type)	
						elsif instr.isQuery #for write query, return boolean
							add_to_cfg_varmap(cfg, c_name, instr.getDefv, "boolean") 
						else
							#normal call instr
							#caller?
							if instr.getCallHandler != nil and instr.getCallHandler.caller != nil
								meth = instr.getCallHandler.caller.getMethod(instr.getFuncname)
								if meth.getCFG != nil
									#Fill in arg types
									if meth.getCFG.arg_types.length == 0
										instr.getArgs.each do |a|
											var = Variable.new(instr.getDefv, "unknown")	
											meth.getCFG.arg_types.push(var)
										end
									end
									temp_index = 0
									instr.getArgs.each do |a|
										if type_not_found(meth.getCFG.arg_types[temp_index])
											#Guess arg type by checking the type of the variable passed to that func call
											if type_not_found(known_type(a, cfg, c_name))
												var = Variable.new("const", a)
												meth.getCFG.arg_types[temp_index] = a.downcase
											else
												meth.getCFG.arg_types[temp_index] = known_type(a, cfg, c_name)
											end
										end
										temp_index += 1
									end
								end
								if meth.getCFG != nil and meth.getCFG.return_type != nil
									add_to_cfg_varmap(cfg, c_name, instr.getDefv, meth.getCFG.return_type.type)
								end
							end
						end
					end
				elsif instr.instance_of?Return_instr
					if instr.getDeps.length > 1
						r_type = nil
						instr.getDeps.each do |d|
							if d.getVname.include?("self")
							else 
								r_type = known_type(d.getVname, cfg, c_name)
							end 
						end
						if type_not_found(r_type)==false
							cfg.return_type = r_type
						end
					else
						var = Variable.new("returnv", "NIL")	
						cfg.return_type = var
					end
				end
			end
			if print
				if type_not_found(known_type(instr.getDefv, cfg, c_name))==false
					puts "\t\t\t # # type: #{instr.getDefv} = #{known_type(instr.getDefv, cfg, c_name).type}"
				elsif instr.getDefv != nil
					puts "\t\t >.< def #{instr.getDefv} not nil"
				end
			end
		end
	end
end
