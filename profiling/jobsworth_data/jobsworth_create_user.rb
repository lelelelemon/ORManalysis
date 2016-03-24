require 'rubygems'
require 'watir-webdriver'
require 'headless'
require 'faker'
load '../util.rb'
load '../general_get_random_text.rb'

headless = Headless.new
headless.start

browser = Watir::Browser.new
$rg = RandomGenerator.new

browser.goto 'localhost:3000/auth/users/sign_in'
browser.text_field(:name => 'user[username]').set 'admin'
browser.text_field(:name => 'user[password]').set 'password'
browser.input(:name => 'commit').click


number_of_users = 32
fname = "user_info.txt"
fp = File.open(fname, "w")

for i in 0...number_of_users
  browser.goto 'localhost:3000/users/new'
  email = Faker::Internet.email
  username = email[0..email.index('@')-1]
  password = Faker::Internet.password(10, 20, true)
  name = Faker::Internet.user_name
  browser.text_field(:name => 'user[name]').set name
  browser.text_field(:name => 'email').set email
  browser.text_field(:name => 'user[username]').set username
  browser.text_field(:name => 'user[password]').set password
  browser.textarea(:name => 'Welcome message').set $rg.getRandomString(200)
  browser.input(:name => 'commit').click
  fp.puts("#{username} #{email} #{password} #{name}")
  puts("User #{i}: #{username} #{email} #{password} #{name}") 
end

headless.destroy
