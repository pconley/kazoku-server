class SummaryController < ApiController
  
  # GET /summary.json
  def show
    p = Person.count
    f = Family.count
    puts "*** SummaryController#show #{p} #{f}"
    @summary = { member_count: p, family_count: f }
  end

end