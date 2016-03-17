require 'faker'
load '../util.rb'
load '../general_get_random_text.rb'
$other_user_emails = Array.new
email_file = File.open("user_email.txt","r")
email_file.each_line do |e|
	username = e[0..e.index('@')-1]
	$other_user_emails.push(username)
end
#Apps can have their own random generator class derived from this class
class LobstersRandomGenerator < RandomGenerator
	def initialize
		super
	end
	def general_get_random_text_for_field(field_name, s)
		size = 20
		if s and s.length > 0
			size = s.to_i
		end
		if field_name == "memo"
			str = @fast_random.getRandomSring(s)
			return str
		elsif field_name.include?("recipient_username")
			r = @fast_random.getRandomInt(0, $other_user_emails.length)
			return $other_user_emails[r]
		elsif field_name.include?"password"
			return Faker::Internet.password(8, s, true)
		elsif field_name.include?"email"
			return Faker::Internet.email
		elsif field_name.include?"username"
			return Faker::Internet.user_name
		elsif field_name.include?"url"
			return Faker::Internet.url
		else
			return @fast_random.getRandomString(s)
		end 
	end
	def get_hidden_field_data(field_hash)
	end
end

