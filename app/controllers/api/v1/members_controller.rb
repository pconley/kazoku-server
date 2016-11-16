module Api
module V1
class MembersController < ApiController

  # GET api/v1/members/1.json
  def show
  	@member = Member.find(params[:id])
  end

  # GET api/v1/members.json
  def index
    puts "*** MembersController: params=#{params.inspect}"

    # support the ability to limit the members returned
    # based on a search string criteria
    if params[:search] && params[:search].length > 0
      @members = Member.search(params[:search]).order(:id)
    else
      @members = Member.all.order(:id)
    end

    # support the ability to return pages of members
    # where each "page" is of a fixed size
    if params[:page] && params[:page].length > 0
      page = params[:page].to_i
      page = 1 if page < 1
      page = page - 1 # zero based paging
      page_size = 20  # the default page size
      page_size = params[:size].to_i if params[:size]
      start = page * page_size
      finish = start + page_size - 1
      puts "*** page #{page} is #{start} to #{finish}"
      @members = @members[start..finish]
    end

    # support the ability to return a range of members
    # from start (zero based) for a number of records (count)
    if params[:start] && params[:count]
      start = params[:start].to_i
      count = params[:count].to_i
      puts "--- Processing range: #{start} to #{start+count-1}"
      @members = @members[start..start+count-1]
    end

  end

end
end
end