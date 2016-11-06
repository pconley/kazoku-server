class AuthService

	def self.fetch_profile(id_token)
	    puts "*** AuthService#fetch_profile: id_token = #{id_token}"
	    return false unless id_token

	    subscriber = self.extract_subscriber(id_token)
	    return false unless subscriber

	    # use the subscriber and id_token to get the user profile information from Auth0
		auth0url = "https://kazoku.auth0.com/api/v2/users/#{subscriber}?include_fields=true"
		uri = URI.parse(URI.escape(auth0url)) # the subscriber has special characters
		req = Net::HTTP::Get.new(uri.to_s,{'Authorization' => "Bearer "+id_token})
		response = Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(req) }
		puts "*** auth0 response = #{response.body}"
		return false if response.body['error']
	  	return response.body # is the profile in a json string
	end

	def self.extract_subscriber(id_token)

		if Rails.configuration.x.auth0.client_secret.nil?
			puts "\n\n**********************************************************************\n*\n"
			puts "*   Auth0 Environment Variables are not set... see /lib/scripts \n*\n"
			puts "**********************************************************************\n\n"
			return nil
		end

		puts "*** AuthService#extract_subscriber id_token=#{id_token}"
		return nil if id_token.nil?
	    # use the specific client secret to decode the raw token into it pieces
		# next line may throw: JWT::DecodeError or JWT::ExpiredSignature
		begin
	    	decoded_secret = JWT.base64url_decode(Rails.configuration.x.auth0.client_secret)
	    	decoded_token = JWT.decode(id_token,decoded_secret)
	    rescue
	    	return nil
	    end
		# make sure this token is really one of ours by checking **audience**
	    return nil if decoded_token[0]["aud"] != Rails.configuration.x.auth0.client_id
	    decoded_token[0]["sub"] # but, return the **subscriber** info
	end


end