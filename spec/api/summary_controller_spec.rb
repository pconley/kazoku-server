require 'rails_helper'

describe "API Summary", :type => :request do

  include AuthHelper # example tokens

  before :each do
    Person.create!
    Person.create!
    Family.create!
  end

  def do_show()
    get '/summary', headers: { 'HTTP_AUTHORIZATION' => valid_token },
          # params: { id: 1 },
          # env: { 'action_dispatch.custom' => 'custom' },
          xhr: true, as: :json
    puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
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