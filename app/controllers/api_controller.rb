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
	    puts "--- raw token = #{raw_token}"
	    unless raw_token
	    	render :json => { :errors => ['missing token'] }, status: 401
	    	return false
	    end

		profile = Profile.find(raw_token)
		#puts "auth0 profile = #{profile}"

		meta = profile['app_metadata']
		return false if meta.nil?

		role = meta['role']
		return false if role.nil?

		puts "*** ApiController#validate_token auth0 role = #{role}"
		return role == "user" || role == "admin"
	end

end
