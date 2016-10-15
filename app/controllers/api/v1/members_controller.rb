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

    if params[:search] && params[:search].length > 0
      @members = Member.search(params[:search]).order(:id)
    else
      @members = Member.all.order(:id)
    end

    # now limit to the requested page
    if params[:page] && params[:page].length > 0
      page = params[:page].to_i
      page = 1 if page < 1
      page = page - 1 # zero based
      page_size = 20
      start = page * page_size
      finish = start + page_size - 1
      puts "*** #{page} :: #{start} .. #{finish}"
      @members = @members[start..finish]
    end

  end

end
end
end