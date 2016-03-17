require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
headless = Headless.new
headless.start

server_file = File.open("/home/congy/ruby_source/lobsters/server.log", "r")
i = 0
email_file = File.open("user_email.txt","r")
email_map = Hash.new
email_file.each_line do |e|
	email_map[e] = ""
end

output_file = File.open("user_info.txt", "w")
cur_email = nil
i = 0
server_file.each_line do |line|
	if line.include?("Hello ")
		cur_email = line.gsub("Hello ","").gsub(",\n","")
	elsif line.include?("whyamilearningruby.com") and line.include?("invitations")
		line = line.gsub("\n","")
		code_start = line.rindex('/')+1
		code = line[code_start..-1]
		email_map[cur_email] = code
		http = "localhost:3000/invitations/#{code}"

		username = cur_email[0..cur_email.index('@')-1]
		password = Faker::Internet.password(10, 20, true)
		puts "email: #{cur_email}, invitation code: #{code}, username = #{username}, password = #{password}"
		browser = Watir::Browser.new
		browser.reset!
		browser.cookies.clear
		browser.goto http
		browser.text_field(:id => 'user_username').set username
		browser.text_field(:id => 'user_password').set password
		browser.text_field(:id => 'user_password_confirmation').set password
		browser.input(:name => 'commit', :value => 'Signup').click
		browser.close
		output_file.puts("#{username} #{password} #{cur_email} #{code}")
	end
end

headless.destroy
