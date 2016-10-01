class MembersController < ApiController
  
  # GET /members.json
  def index
    puts "*** MembersController: params=#{params.inspect}"

    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all.take(10)
    end
  end

end
