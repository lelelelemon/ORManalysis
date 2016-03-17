require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
headless = Headless.new
headless.start

browser = Watir::Browser.new
browser.goto 'localhost:3000/login'
browser.text_field(:name => 'email').set 'test'
browser.text_field(:name => 'password').set 'test'
browser.input(:name => 'commit').click

number_of_users = 10000
fpname = "user_email.txt"
fp = File.open(fpname, "w")

for i in 0...number_of_users
	email = Faker::Internet.email
	browser.goto 'localhost:3000/settings'
	browser.text_field(:name => 'email').set email
	browser.text_field(:name => 'memo').set "#{Faker::Name.name}"
	browser.input(:name => 'commit', :value => 'Send Invitation').click
	fp.puts(email)
end

headless.destroy
