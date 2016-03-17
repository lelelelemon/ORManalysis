def handle_single_href_request(href, depth)
	puts "Depth #{depth} -> HREF: goto #{href}"
	visit_page("#{$prefix}/#{href}", depth+1)
end

load 'lobsters_get_random_text.rb'

def handle_single_formfor_request(form, depth)
	submit_hash = nil
	form.css("input[type]").each do |input|
		if input.attr("type") == "submit"
			submit_hash = {}
			if input.attr("name") and input.attr("name").length > 0
				submit_hash["name"] = input.attr("name")
			end
			if input.attr("id") and input.attr("id").length > 0
				submit_hash["id"] = input.attr("id")
			end
			if input.attr("value") and input.attr("value").length > 0
				submit_hash["value"] = input.attr("value")
			end
		end
	end
	puts "Submit hash = #{submit_hash.inspect}"
	form.css("input[name]").each do |input|
		name = input.attr("name")
    value = input.attr("value")
		type = input.attr("type")
		id = input.attr("id")
		size = input.attr("size")
		field_hash = {}
		field_hash["value"] = ""
		field_hash["name"] = ""
		field_hash["id"] = ""
		if value and value.length > 0
			field_hash["value"] = value
		end
		if name and name.length > 0
			field_hash["name"] = name
		end
		if id and id.length > 0
			field_hash["id"] = id
		end
		puts "Depth #{depth} -> Filling in form: type = #{type}, field_hash = #{field_hash.inspect}, size = #{size}"
		if type == "hidden"
		#If value != nil, then this field has already been filled?
		elsif type == "text" #and value == nil
			#This function should be tailored for different apps
			$rg.get_text_field_data(field_hash, size)
		elsif type == "checkbox"
			$rg.get_checkbox_data(field_hash)
		elsif type == "radio"
			$rg.get_radio_data(field_hash)
		elsif type == "submit"
			#Submit will happen last
			#$browser.input(field_hash).click
		end
	end
	if submit_hash
		if submit_hash["name"]
			$browser.input(:name => submit_hash["name"]).click
		else
			$browser.input(:value => submit_hash["value"]).click
		end
	end

	if $browser.html.include?("error") or $browser.html.include?("Error") or $browser.html.include?("ERROR")
		exit
	end
	#visit_page("#{$browser.url}", depth+1)
end

