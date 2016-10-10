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
			#puts "--- preflight check!"
		    cors_set_access_control_headers()
		    render :text => '', :content_type => 'text/plain'
		end
	end

	def validate_token
		@current_profile = nil

		request_headers.each {|key, value| puts "*** header #{key} is #{value}" }

	    # get the auth0 jwt token from the request header
	    raw_token = request.headers['HTTP_AUTHORIZATION']
	    puts "*** ApiController#validate_token raw_token = #{raw_token}"
	    unless raw_token
	    	render :json => { :errors => ['missing token'] }, status: 401
	    	return false
	    end

		profile = ProfileService.find(raw_token)
		#puts "*** ApiController#validate_token profile = #{profile}"
	    unless profile
	    	render :json => { :errors => ['invalid token'] }, status: 401
	    	return false
	    end

		is_authorized = ['user','admin'].include? profile.role
		#puts "*** ApiController#validate_token authorized = #{is_authorized}"
		unless is_authorized
	    	render :json => { :errors => ['invalid profile'] }, status: 401
	    	return false
	    end

	    @current_profile = profile
	end

end
