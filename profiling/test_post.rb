require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'nokogiri'
headless = Headless.new
headless.start

$browser = Watir::Browser.new
$browser.goto "localhost:3000/login"
$browser.text_field(:name => 'email').set 'test'
$browser.text_field(:name => 'password').set 'test'
$browser.input(:name => 'commit').click

puts $browser.html
target="http://localhost:3000/stories/qwzy86/unvote"


html="<html><head></head><body>\n"
html+='<form name="random_form" method="post" action="'+target+'">'+"\n"
html+='<input type="submit">'+"\n"
html+='</form></body></html>'

puts html
puts ""

location = "file:///home/congy/ruby_source/ORM_analysis/profiling/test.html"
puts location
fp=File.open("test.html", "w")
fp.puts(html)
fp.close

#View the generate HTML page
$browser.goto location
$browser.input().click

headless.destroy
