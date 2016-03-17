require 'faker'
load 'util.rb'
#Apps can have their own random generator class derived from this class
class RandomGenerator
	def initialize
		@fast_random = Fast_random.new($prng.rand(126498))
	end
	def getRandomInt(min, max)
		return @fast_random.getRandomInt(min, max)
	end
	def getRandomString(len)
		return @fast_random.getRandomString(len)
	end
	def general_get_random_text_for_field(field_name, s)
		size = 20
		if s and s.length > 0
			size = s.to_i
		end
		if field_name == "memo"
			str = @fast_random.getRandomSring(s, 10)
			return str
		elsif field_name.include?"password"
			return Faker::Internet.password(8, s, true)
		elsif field_name.include?"email"
			return Faker::Internet.email
		elsif field_name.include?"username"
			return Faker::Internet.user_name
		else
			@fast_random.getRandomString(s, 10)
			return str
		end
	end
	def getRandomBoolean(field_name)
		i = $prng.rand(2)
		if i == 0
			return true
		else
			return false
		end
	end
	def get_hidden_field_data(field_hash)
	end
	def get_checkbox_data(field_hash)
		r = self.getRandomBoolean(field_hash["name"])
		if r == 0
		else
			$browser.checkbox(:name => field_hash["name"]).set
		end
	end
	def get_text_field_data(field_hash, size)
		set_value = self.general_get_random_text_for_field(field_hash["name"], size)
		puts "\t\t set_value = #{set_value}"
		$browser.text_field(:name => field_hash["name"], :id => field_hash["id"]).set set_value
	end
	def get_radio_data(field_hash)
		r = self.getRandomBoolean(field_hash["name"])
		if r == 0
		else
			$browser.radio(:value => field_hash["value"]).set
		end
	end
end
