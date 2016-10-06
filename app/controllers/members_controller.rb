class MembersController < ApiController
  
  # GET /members.json
  def index
    puts "*** MembersController: params=#{params.inspect}"

    if params[:search] && params[:search].length > 0
      @people = Person.search(params[:search])
    else
      @people = Person.all.take(103)
    end

    # now limit to the requested page
    if params[:page] && params[:page].length > 0
      page = params[:page].to_i
      page = 1 if page < 1
      page-- # zero based
      page_size = 20
      start = page * page_size
      finish = start + page_size - 1
      @people = @people[start..finish]
    end

  end

end
