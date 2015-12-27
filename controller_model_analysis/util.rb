$fast_random = nil
class Fast_random
	def initialize(seed)
		@seed = seed
	end
	def internal_next(bits)
    @seed = (@seed * 0x5DEECE66D + 0xB) & ((1 << 48) - 1);
    return (@seed >> (48 - bits));
  end
	def next
    return (self.internal_next(32) << 32) + self.internal_next(32);
  end
	def next_bound(lower, upper)
		return lower + self.next.modulo(upper-lower)
	end
end
