class MembersController < ApplicationController

	require 'jwt'

	protect_from_forgery

	before_filter :cors_preflight_check

	after_filter :cors_set_access_control_headers

	before_filter :check_id_token #, except: [ :index ]

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

    def check_id_token
    	id_token = request.headers['HTTP_AUTHORIZATION']

		# Set password to nil and validation to false otherwise this won't work
		decoded_token = JWT.decode id_token, nil, false
		puts "decoded token = #{decoded_token}"


    	puts "--- check id token = #{id_token[0..20]}..."
    	if id_token[0..3] != "eyJ0"
    		puts "--- invalid id token"
    		render :text => "Un-authorized!", :content_type => 'text/plain', :status => 401
     	end
    end

    class InvalidTokenError < StandardError; end

def validate_token
  begin
    auth0_client_id = '6VtNWmSNXVxLDCxiDQaE6xGbBAbs4Nkk'
    auth0_client_secret = 'czyAb3eHSTKiSGrqm3wq-ahwbvSGN37wSDS-zx8x5FAhPy7w2V7TTi-KI6vhTNyo'
    authorization = request.headers['Authorization']
    raise InvalidTokenError if authorization.nil?

    token = request.headers['HTTP_AUTHORIZATION'].split(' ').last
    puts "--- token = #{token}"
    decoded_token = JWT.decode(token,JWT.base64url_decode(auth0_client_secret))
	puts "decoded token with clues = #{decoded_token}"

    raise InvalidTokenError if auth0_client_id != decoded_token[0]["aud"]


	auth0url = "https://kazoku.auth0.com/api/v2/users/auth0%7C57d226d9a164af8c3bee2bee?fields=name&include_fields=true"
	uri = URI.parse(auth0url)
	req = Net::HTTP::Get.new(uri.to_s,{'Authorization' => "Bearer "+token})
	# req.use_ssl = true
	# req.verify_mode = OpenSSL::SSL::VERIFY_NONE 
	response = Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(req) }
	puts "auth0 response = #{response.body}"


  rescue JWT::DecodeError
    raise InvalidTokenError
  end
end
  
  # GET /members.json
  def index
    puts "*** MembersController: index search=#{params[:search]}"

    validate_token

    # request.headers.each { |key, value| puts ">>> #{key}: #{value}" }

    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all.take(10)
    end
  end

end
