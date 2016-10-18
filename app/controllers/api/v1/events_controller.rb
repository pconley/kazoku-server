module Api
module V1
class EventsController < ApiController

  def show
  	@event = Event.find(params[:id])
  end

  def index
    puts "*** EventsController: params=#{params.inspect}"

    if params[:month] && params[:search].length > 0
      @events = Event.search(params[:search]).order(:id)
    else
      @events = Event.all.order(:id)
    end

  end

end
end
end