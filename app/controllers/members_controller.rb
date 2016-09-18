class MembersController < ApplicationController

	include Knock::Authenticable

	before_action :authenticate # knock's version

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
    	puts "--- check id token = #{id_token[0..20]}..."
    	if id_token[0..3] != "eyJ0"
    		puts "--- invalid id token"
    		render :text => "Un-authorized!", :content_type => 'text/plain', :status => 401
     	end
    end
  
  # GET /members.json
  def index
    puts "*** MembersController: index search=#{params[:search]}"

    # request.headers.each { |key, value| puts ">>> #{key}: #{value}" }

    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all.take(10)
    end
  end

end
