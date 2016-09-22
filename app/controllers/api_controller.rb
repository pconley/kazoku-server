class ApiController < ApplicationController

	require 'jwt'

	protect_from_forgery

	before_action :cors_preflight_check

	before_action :validate_token #, except: [ :index ]

	after_action :cors_set_access_control_headers

	def cors_set_access_control_headers
		puts "--- setting access control headers"
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
		headers['Access-Control-Allow-Headers'] = '*,authorization,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
		headers['Access-Control-Max-Age'] = "1728000"
	end

	def cors_preflight_check
		# If this is a preflight OPTIONS request, then short-circuit the
		# request, return only the necessary headers and return an empty
		# text/plain.
		if request.method == :options || request.method == 'OPTIONS'
			puts "--- preflight check!"
		    cors_set_access_control_headers()
		    render :text => '', :content_type => 'text/plain'
		end
	end

	def validate_token
	    # get the auth0 jwt token from the request header
	    raw_token = request.headers['HTTP_AUTHORIZATION']
	    #puts "--- raw token = #{raw_token}"
	    return false if raw_token.nil?

		profile = get_auth0_profile(raw_token)
		#puts "auth0 profile = #{profile}"

		meta = profile['app_metadata']
		return false if meta.nil?

		role = meta['role']
		return false if role.nil?

		puts "*** ApiController#validate_token auth0 role = #{role}"
		return role == "user" || role == "admin"
	end

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
	    $redis.expire(sub,10*60) # 10 minutes

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


	def xfetch_auth0_profile(raw_token)
	    # get the auth0 jwt token from the request header
	    raw_token = request.headers['HTTP_AUTHORIZATION']
	    #puts "--- raw token = #{raw_token}"
	    return false if raw_token.nil?

	    # use the client secret to decode the raw token into it pieces
	    auth0_client_secret = 'czyAb3eHSTKiSGrqm3wq-ahwbvSGN37wSDS-zx8x5FAhPy7w2V7TTi-KI6vhTNyo'
	    decoded_token = JWT.decode(raw_token,JWT.base64url_decode(auth0_client_secret))
		#puts "--- decoded token = #{decoded_token}"

		# make sure this token is really one of ours by checking audience
	    auth0_client_id = '6VtNWmSNXVxLDCxiDQaE6xGbBAbs4Nkk'
	    audience = decoded_token[0]["aud"]
	    #puts "--- audience = #{audience}"
	    return false if audience.nil?
	    return false if audience != auth0_client_id

	    subscriber = decoded_token[0]["sub"]
	    #puts "--- subscriber = #{subscriber}"
	    return false if subscriber.nil?

	    # use the subscriber and raw_token to get the user profile information
	    # by making a call to Auth0 server
		auth0url = "https://kazoku.auth0.com/api/v2/users/#{subscriber}?include_fields=true"
		uri = URI.parse(URI.escape(auth0url)) # the subscriber has special characters
		req = Net::HTTP::Get.new(uri.to_s,{'Authorization' => "Bearer "+raw_token})
		response = Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(req) }
		#puts "*** auth0 response = #{response.body}"

		begin
			profile = JSON.parse(response.body)
		rescue JWT::DecodeError
	    	raise InvalidTokenError
	  	end

	  	return profile
	end

end
