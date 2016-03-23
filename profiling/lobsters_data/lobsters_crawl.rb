require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
require 'net/http'
require 'nokogiri'
load 'lobsters_global.rb'
load '../util.rb'
load '../helper.rb'
load  'lobsters_entrance.rb'
load 'lobsters_get_random_text.rb'
load '../handle_requests.rb'
#headless = Headless.new
#headless.start

$browser = Watir::Browser.new
$browser.goto "#{$prefix}/login"
$browser.text_field(:name => 'email').set 'test'
$browser.text_field(:name => 'password').set 'test'
$browser.input(:name => 'commit').click

$rg = LobstersRandomGenerator.new
$cur_url = nil
$visited = Array.new

$output_file = File.open("reached_urls.txt", "w")

$global_r = Random.new(1327)

$global_stack = Array.new

def visit_page(url, depth)
	if $visited.include?(url)
		return
	end
	$reject_url_list.each do |r|
		if url.include?r
			return
		end
	end
	if depth > 15
		return
	end
	$visited.push(url)
	$cur_url = url
	$output_file.puts(url)
	
	$browser.goto url
	getStoryIds(url, $browser.html)
	getCommentIds(url, $browser.html)
	
	hrefs = get_href_tag_array_from_html($browser.html)	
	forms = get_form_tag_array_from_html($browser.html)

	puts "\tHREF len = #{hrefs.length}, FORMS len = #{forms.length}"
	#DFS but only print forms, but random shuffle

	#	rnd = $rg.getRandomInt(0,100)
#	if rnd < $select_root_perc
	if $select_root_perc % 8==0
		loc = generateEntrancePage
		visit_page(loc, 0)
	end
  $select_root_perc+=1

	forms.shuffle!(random: $global_r)
	hrefs.shuffle!(random: $global_r)
	#randomly select a form...
	if forms.length > 0
		i = $rg.getRandomInt(0, forms.length)
		form = forms[i]
		action = form.attr("action")
		$output_file.puts("#{url}\tPOST: #{action}")
		handle_single_formfor_request(form, depth)
	end
	i = 0
	hrefs.each do |href|
		if $visited.include?(href)
		else
			$visited.push(href)
			$global_stack.push(i)
			handle_single_href_request(href, depth)
			$global_stack.pop
		end
		i += 1
	end

#	rnd = $rg.getRandomInt(0,100)
#	if rnd < $select_root_perc
#	$select_root_perc+=1
#	if $select_root_perc == 11
#		loc = generateEntrancePage
#		visit_page(loc, 0)
#	end
	#Random get field
	#if forms.length > 0
	#	r = $rg.getRandomInt(0, forms.length)
	#	handle_single_formfor_request(forms[r], depth)
	#end
	#if hrefs.length > 0
	#	numberOfHrefs = $rg.getRandomInt(0, hrefs.length)
	#	for i in 0...numberOfHrefs
	#		r = $rg.getRandomInt(0, hrefs.length)
	#		handle_single_href_request(hrefs[r], depth)
	#	end
	#end
end


visit_page("#{$prefix}/recent", 0)


#headless.destroy
