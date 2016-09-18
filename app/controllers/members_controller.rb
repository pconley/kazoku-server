class MembersController < ApplicationController

	protect_from_forgery

	before_filter :cors_preflight_check
	after_filter :cors_set_access_control_headers

# For all responses in this controller, return the CORS access control headers.

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  # headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  # headers['Access-Control-Allow-Headers'] = '*'
  headers['Access-Control-Max-Age'] = "1728000"

   headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
   headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
end

# If this is a preflight OPTIONS request, then short-circuit the
# request, return only the necessary headers and return an empty
# text/plain.

def cors_preflight_check
  if request.method == :options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = '1728000'
    render :text => '', :content_type => 'text/plain'
  end
end
  
  # GET /members.json
  def index
    puts "*** MembersController: index search=#{params[:search]}"
    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all
    end
  end

end
