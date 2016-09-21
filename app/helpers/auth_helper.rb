class InvalidTokenError < StandardError; end

module AuthHelper

	AUTH0_CLIENT_ID     = '6VtNWmSNXVxLDCxiDQaE6xGbBAbs4Nkk'
	AUTH0_CLIENT_SECRET = 'czyAb3eHSTKiSGrqm3wq-ahwbvSGN37wSDS-zx8x5FAhPy7w2V7TTi-KI6vhTNyo'

	def get_auth0_profile(id_token)

	    puts "*** AuthHelper#get_auth0_profile. token = #{id_token}"

	    sub = extract_subscriber(id_token)

	    # TODO: look up and return profile in table or cache
	    cached = $redis.get(sub)
	    puts "*** cached: #{sub} = #{cached}"

	    # fetch the profile from the auth0 server
	    profile = fetch_auth0_profile(sub,id_token)	

	    # TODO: save profile to the table or cach for next
	    $redis.set(sub,"i was here") 

	    return profile   
	end

	def extract_subscriber(id_token)
		raise InvalidTokenError if id_token.nil?
	    # use the specific client secret to decode the raw token into it pieces
		# next line may throw: JWT::DecodeError or JWT::ExpiredSignature
	    decoded_token = JWT.decode(id_token,JWT.base64url_decode(AUTH0_CLIENT_SECRET))
		# make sure this token is really one of ours by checking **audience**
	    raise InvalidTokenError if decoded_token[0]["aud"] != AUTH0_CLIENT_ID
	    decoded_token[0]["sub"] # but, return the **subscriber** info
	end

	def fetch_auth0_profile(subscriber,id_token)
	    puts "*** AuthHelper#fetch_auth0_profile. subscriber = #{subscriber}"
	    return false if id_token.nil?
	    return false if subscriber.nil?

	    # use the subscriber and id_token to get the user profile information from Auth0
		auth0url = "https://kazoku.auth0.com/api/v2/users/#{subscriber}?include_fields=true"
		uri = URI.parse(URI.escape(auth0url)) # the subscriber has special characters
		req = Net::HTTP::Get.new(uri.to_s,{'Authorization' => "Bearer "+id_token})
		response = Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(req) }
		puts "*** auth0 response = #{response.body}"

		# next line may throw: JSON::ParserError
		profile = JSON.parse(response.body)

	  	return profile
	end
end