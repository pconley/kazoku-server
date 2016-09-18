class MembersController < ApplicationController

	protect_from_forgery

	before_filter :cors_preflight_check

	after_filter :cors_set_access_control_headers

	# before_action :authenticate #, except: [ :index ]

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

	TOKEN = "secret"

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # Compare the tokens in a time-constant manner, to mitigate
        # timing attacks.
        puts "--- token = #{token}"
        # ActiveSupport::SecurityUtils.secure_compare(
        #   ::Digest::SHA256.hexdigest(token),
        #   ::Digest::SHA256.hexdigest(TOKEN)
        #
        true
      end
    end
  
  # GET /members.json
  def index
    puts "*** MembersController: index search=#{params[:search]}"

    # a = authenticate

    puts "--- authenticate = #{authenticate()}"

    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all
    end
  end

end
