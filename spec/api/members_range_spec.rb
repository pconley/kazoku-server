require 'rails_helper'

describe "API Members Range", :type => :request do

  include ApiHelper

  before :each do
    (0..30).each { |n| Member.create! }
    puts ">>> member count = #{Member.all.count}"
  end

  def do_get(start,count)
  	api_get "members", { start: start, count: count }
    expect(response).to be_success
    expect(response.status).to eq(200)
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'responds with the range of members' do
  	count = 10
    body = do_get(5,count)
    expect(body.length).to eq(count)
  end
  
   it 'big request responds with remaining members' do
  	start = 5
    body = do_get(start,1000)
    expect(body.length).to eq(Member.all.count-start)
  end
end