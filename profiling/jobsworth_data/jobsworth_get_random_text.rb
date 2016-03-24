require 'faker'
load '../util.rb'
load '../general_get_random_text.rb'

class JobsworthRandomGenerator < RandomGenerator
	def initialize
		super
	end
	def general_get_random_text_for_field(field_name, s)
		if field_name == "project[default_estimate]"
			return self.getRandomInt(0, 5).to_s
		else
			super
		end
	end
end
