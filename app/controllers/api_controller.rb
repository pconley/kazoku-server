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
	    puts "*** ApiController#get_auth0_profile. token = #{id_token}"
	    sub = extract_subscriber(id_token)
	    # first, try to fetch the profile from the cache
	    profile_cache= $redis.get(sub)
	    if profile_cache
	    	puts "*** using CACHED profile = #{profile_cache}"
	    	# next line may throw: JSON::ParserError
	    	return JSON.parse(profile_cache)
	    else
	    	# fetch the profile from the auth0 server
	    	profile_fetch = fetch_auth0_profile(sub,id_token)
	    	puts "*** using FETCHED profile = #{profile_fetch}"
		    # may still not have a valid profile if invalid
		    return false if profile_fetch.nil?
		    # next line may throw: JSON::ParserError
		    # so we parse BEFORE we cache the profile
		    profile = JSON.parse(profile_fetch)
		    # save the profile to the cache
		    $redis.set(sub,profile_fetch) 
		    # but set to expire in N minutes
		    $redis.expire(sub,10*60)
		    return  profile
		end
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
	    puts "*** ApiController#fetch_auth0_profile. subscriber = #{subscriber}"
	    return false if id_token.nil?
	    return false if subscriber.nil?

	    # use the subscriber and id_token to get the user profile information from Auth0
		auth0url = "https://kazoku.auth0.com/api/v2/users/#{subscriber}?include_fields=true"
		uri = URI.parse(URI.escape(auth0url)) # the subscriber has special characters
		req = Net::HTTP::Get.new(uri.to_s,{'Authorization' => "Bearer "+id_token})
		response = Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(req) }
		puts "*** auth0 response = #{response.body}"

	  	return response.body # is the profile in a json string
	end

end
