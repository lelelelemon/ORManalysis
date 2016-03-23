def handle_single_href_request(href, depth)
	str = ""
	$global_stack.each do |g|
		str += "#{g} "
	end
	puts "=== #{str} ==="
	puts "Depth #{depth} -> HREF: goto #{href}"
	visit_page("#{$prefix}/#{href}", depth+1)
end


def get_field_hash(input)
	name = input.attr("name")
  value = input.attr("value")
	type = input.attr("type")
	id = input.attr("id")
	size = input.attr("size")
	klass = input.attr("class")
	field_hash = {}
	if value and value.length > 0
		field_hash["value"] = value
	end
	if name and name.length > 0
		field_hash["name"] = name
	end
	if id and id.length > 0
		field_hash["id"] = id
	end
	if klass and klass.length > 0
		field_hash["class"] = klass
	end
	return field_hash
end

#test if an attr of an element is distinct among element_list
def testDistinctAttr(attr, element, element_list)
	#such an attribute exist
	if element.attr(attr) 
		element_list.each do |e|
			if e != element
				if e.attr(attr) == element.attr(attr)
					return false
				end
			end
		end	
		return true
	end
	return false
end
#button can have the form of "button" or "input"
#reserved: avoid_list, an array of certain buttons that cannot be clicked
def clickRandomButton(submit_list, button_list)
	#first pick one button/submit
	total_buttons = submit_list.length + button_list.length
	if total_buttons == 0
		return
	end
	i = $rg.getRandomInt(0, total_buttons)
	if i < submit_list.length
		click_name = submit_list[i].attr("name")
		click_value = submit_list[i].attr("value")
		click_id = submit_list[i].attr("id")
		#check if it has distinct name
		if testDistinctAttr("name", submit_list[i], submit_list) 
			$browser.input(:name => click_name).click
		#check if it has distinct id
		elsif testDistinctAttr("id", submit_list[i], submit_list)
			$browser.input("name" => click_id).click
		elsif testDistinctAttr("value", submit_list[i], submit_list)
			$browser.input("value" => click_value).click
		elsif click_name
			$browser.input("name" => click_name).click
		elsif click_id
			$browser.input("id" => click_id).click
		elsif click_value
			$browser.input("value" => click_value).click
		end
	else
		i = i-submit_list.length
		#TODO: if there is an avoid_list, then I shouldn't use "index"...
		$browser.button(:index => i).click
	end
end

def handle_single_formfor_request(form, depth)
	checkbox_index = 0
	radio_index = 0
	text_field_index = 0
	@submit_list = Array.new	
	form.css("input[name]").each do |input|
		field_hash = get_field_hash(input)
		type = input.attr("type")
		id = input.attr("id")
		size = input.attr("size")

		#puts "Depth #{depth} -> Filling in form: type = #{type}, field_hash = #{field_hash.inspect}, size = #{size}"
		if type == "hidden"
		#If value != nil, then this field has already been filled?
		elsif type == "text" #and value == nil
			#This function should be tailored for different apps
			$rg.get_text_field_data(field_hash, text_field_index, size)
			text_field_index += 1
		elsif type == "checkbox"
			$rg.get_checkbox_data(field_hash, checkbox_index)
			checkbox_index += 1
		elsif type == "radio"
			$rg.get_radio_data(field_hash, radio_index)
			radio_index += 1
		elsif type == "submit"
			puts "ADD SUBMIT: #{input.inspect}"
			@submit_list.push(input)
		end
	end

	@button_list = Array.new
	form.css("button").each do |input|
		@button_list.push(input)
	end
	
	text_area_index = 0
	form.css("textarea[name]").each do |input|
		field_hash = get_field_hash(input)
		size = input.attr("size")
		$rg.get_text_area_data(field_hash, text_area_index, size)
		text_area_index += 1
	end

	#TODO: use avoid_list to filter out buttons/submits...
	clickRandomButton(@submit_list, @button_list)

	if $browser.html.include?("error") or $browser.html.include?("Error") or $browser.html.include?("ERROR")
		#exit
		puts "ERROR: url = #{$browser.url}"
	end

	#visit_page("#{$browser.url}", depth+1)
end

