class ProfileService

	def self.find(id_token)
	    puts "*** ProfileService#find: token = #{id_token}"
	    sub = AuthService.extract_subscriber(id_token)
	    puts "--- ProfileService#find: sub = #{sub}"

	    return nil unless sub # if not found in token

	    # first, try to get the profile from the cache
	    json = CacheService.try(:get_profile,sub)
	    if json
	    	puts "*** using FETCHED profile = #{json}"
	    else
	    	# fetch the profile from the auth service
	    	json = AuthService.fetch_profile(id_token)
	    	puts "*** no profile to use" unless json
			return nil unless json
			puts "*** using FETCHED profile = #{json}"

		 	# only save in cache if it is valid json
		 	valid = JSON.parse(json) rescue nil
		    CacheService.save_profile(sub, json) if valid
		end

		return  self.from_json(json)
	end

	def self.from_json(json)
		role = extract_meta(:role,json)
		name = extract(:nickname,json)
		email = extract(:email,json)
		Profile.new(role: role, email: email, name: name)
	end

	def self.extract(sym,json)
		return nill unless json
		valid = JSON.parse(json) rescue nil
		return nill unless valid
		return valid[sym.to_s]
	end

	def self.extract_meta(sym,json)
		return nil unless json
		valid = JSON.parse(json) rescue nil
		return nil unless valid
		meta = valid['app_metadata']
		return nill unless meta
		return meta[sym.to_s]
	end

end