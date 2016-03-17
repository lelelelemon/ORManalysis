require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
require 'net/http'
require 'nokogiri'
load '../helper.rb'
load '../lobsters_get_random_text.rb'
load '../handle_requests.rb'
#headless = Headless.new
#headless.start

$prefix = "localhost:3000/"
#Avoid going to these urls...
$reject_url_list = Array.new
$reject_url_list.push("/settings")
$reject_url_list.push("/logout")

$browser = Watir::Browser.new
$browser.goto "#{$prefix}/login"
$browser.text_field(:name => 'email').set 'test'
$browser.text_field(:name => 'password').set 'test'
$browser.input(:name => 'commit').click

$rg = LobstersRandomGenerator.new
$cur_url = nil
@visited = Array.new

$output_file = File.open("reached_urls.txt", "w")

def visit_page(url, depth)
	if @visited.include?(url)
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
	@visited.push(url)
	$cur_url = url
	$output_file.puts(url)
	$browser.goto url
	hrefs = get_href_tag_array_from_html($browser.html)	
	forms = get_form_tag_array_from_html($browser.html)

	#DFS but only print forms, but random shuffle
	forms.shuffle
	hrefs.shuffle
	forms.each do |form|
		handle_single_formfor_request(form, depth)
	end
	hrefs.each do |href|
		if @visited.include?(href)
		else
			@visited.push(href)
			handle_single_href_request(href, depth)
		end
	end

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


visit_page("#{$browser.url}", 0)


#headless.destroy
