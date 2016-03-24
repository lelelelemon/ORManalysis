require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
require 'net/http'
require 'nokogiri'
load 'jobsworth_global.rb'
load '../util.rb'
load '../helper.rb'
load 'jobsworth_get_random_text.rb'
load '../handle_requests.rb'

$browser = Watir::Browser.new
$rg = JobsworthRandomGenerator.new

#kenton kenton@kertzmann.info 2vRaLyCb46P lonnie
$browser.goto 'localhost:3000/auth/users/sign_in'
$browser.text_field(:name => 'user[username]').set 'kenton'
$browser.text_field(:name => 'user[password]').set '2vRaLyCb46P'
$browser.input(:name => 'commit').click

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

	hrefs = get_href_tag_array_from_html($browser.html)	
	forms = get_form_tag_array_from_html($browser.html)

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
	exit
	i = 0
	hrefs.each do |href|
		if $visited.include?(href)
		else
			$visited.push(href)
			handle_single_href_request(href, depth)
		end
		i += 1
	end

end

visit_page("#{$prefix}/tasks/new", 0)
