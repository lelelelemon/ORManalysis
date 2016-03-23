class Fast_random
	def initialize(seed)
		@seed = seed
		@seed_base = [1, 3, 2, 2, 4, 2, 3, 1, 0, 5, 2, 4, 3, 1, 6, 3, 1, 1, 4, 2, 7, 4, 3, 1, 5, 2, 8, 4, 0, 3, 9, 2, 1, 7, 3, 5, 2, 8, 6, 11, 9, 2, 3, 5, 0, 0, 1, 8, 2, 11, 4, 5, 3, 7, 1, 8, 2, 6, 0, 1, 3, 5, 9, 2, 1, 6, 3, 4, 4, 7, 2, 8, 3, 1, 5, 0, 3, 4, 8]
	end
	def internal_next(bits)
    @seed = (@seed * 0x5DEECE66D + 0xB) & ((1 << 48) - 1);
    return (@seed >> (48 - bits));
  end
	def next
    return (self.internal_next(32) << 32) + self.internal_next(32);
  end
	#[lower, upper)
	def next_bound(lower, upper)
		if lower == upper
			return lower
		else
			return lower + @seed_base[self.next.modulo(@seed_base.length)].modulo(upper-lower)
		end
	end
	def getRandomString(len, min=4)
		actual_len = self.next_bound(min, len.to_i)
		str = ""
		for i in 0..actual_len
			#[A-Z][a-z][0-9][_]
			temp = next_bound(0,26+26+10+10)
			if temp<26
				str += (temp + 'A'.ord).chr
			elsif temp<52
				str += (temp-26+'a'.ord).chr
			elsif temp<62
				str += (temp-52+'0'.ord).chr
			else
				str += '_'
			end
		end
		return str
	end
	def getRandomInt(min, max)
		return next_bound(min, max)
	end
end

$prng = Random.new
#$fast_random = Fast_random.new(prng.rand(126498))


def random_shuffle_array(ary)
	new_ary = Array.new
end
