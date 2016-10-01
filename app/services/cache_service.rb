class CacheService

	def self.clear
  		keys = $redis.keys "kz:*"
  		$redis.del(*keys) unless keys.empty?
	end

	def self.profile_key(key)
		return "kz:profile:#{key}"
	end

	def self.save_profile(key,profile,exp=10)
	    puts "*** CacheService#save_profile key = #{key}"
		$redis.set(self.profile_key(key),profile) 
		# but set to expire in N minutes
		$redis.expire(self.profile_key(key),exp*60)
	end

	def self.get_profile(key)
		return $redis.get(self.profile_key(key))
	end

end