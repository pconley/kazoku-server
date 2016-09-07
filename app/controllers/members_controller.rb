class MembersController < ApplicationController
  
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
