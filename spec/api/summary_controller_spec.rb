require 'rails_helper'

describe "API Summary", :type => :request do

  include ApiHelper

  before :each do
    Person.create!
    Person.create!
    Family.create!
  end

  def do_show()
    api_get "summary", {}
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'responds with counts' do
    body = do_show()
    expect(response).to be_success
    expect(response.status).to eq(200)
    expect(body['member_count']).to eq(Person.count)
    expect(body['family_count']).to eq(Family.count)
  end
  
end