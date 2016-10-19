module Api
module V1
class EventsController < ApiController

  def show
  	@event = Event.find(params[:id])
  end

  def index
    puts "*** EventsController: params=#{params.inspect}"
    puts "year = #{params[:month]}"
    puts "year = #{params['month']}"
    @events = Event.all.order(:id)
    @events = @events.for_month(params[:month].to_i) if params[:month] 
    @events = @events.for_year(params[:year].to_i) if params[:year] 
    @events = @events.for_day(params[:day].to_i) if params[:day] 
  end

end 
end
end