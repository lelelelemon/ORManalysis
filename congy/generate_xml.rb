def generate_method_xml(file, method, caller_class)
	file.puts("\t<method name = \"#{method.getName}\">")
	method.getCalls.each do |call|
		callerv_name = call.findCaller(caller_class, method.getName)
		callerv = $class_map[callerv_name]
		if call.isQuery
			file.puts("\t\t<query>")
			file.puts("\t\t\t<text>#{call.getObjName} . #{call.getFuncName}<\/text>")
			call.getParams.each do |param|
				if param.getVar.length > 0
					file.puts("\t\t\t<input>#{param.getVar}<\/input>")
				end
			end
			if call.getReturnValue.length > 0
				file.puts("\t\t\t<return>#{call.getReturnValue}<\/return>")
			end
			file.puts("\t\t<\/query>")
		elsif callerv != nil
			if callerv.class.to_s == "Controller_class"
				file.puts("\t\t<call class=\"#{transform_controller_name(callerv.getName)}\" class_type = \"controller\" function_name=\"#{call.getFuncName}\">")
			else
				file.puts("\t\t<call class=\"#{callerv.getName.downcase}\" class_type = \"model\" function_name=\"#{call.getFuncName}\">")
			end
			call.getParams.each do |param|
				if param.getVar.length > 0
					file.puts("\t\t\t<feed>#{param.getVar}<\/feed>")
				end
			end
			if call.getReturnValue.length > 0
				file.puts("\t\t\t<get>#{call.getReturnValue}<\/get>")
			end
			file.puts("\t\t<\/call>")
		end
	end	
	file.puts("\t<\/method>")
end

def generate_xml_files
	$class_map.each do |keyc, valuec|
		filename = ""
		if valuec.class.to_s == "Model_class"
			filename = "./xmls/#{keyc.downcase}_model.xml"
		else
			filename = "./xmls/#{transform_controller_name(keyc)}.xml"
		end
		file = File.open(filename, "w")
		puts "Generate file: #{filename}"
		if valuec.class.to_s == "Model_class"
			file.puts("<model>")
		else
			file.puts("<controller>")
		end

		valuec.getMethods.each do |key, value|
			generate_method_xml(file, value, keyc)
		end
		
		if valuec.class.to_s == "Model_class"
			file.puts("<\/model>")
		else
			file.puts("<\/controller>")
		end
	end
end

