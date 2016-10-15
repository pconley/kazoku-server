require 'rails_helper'

describe "API Members Paging", :type => :request do

  include AuthHelper # example tokens

  before :each do
    [0..20].each { |n| Member.create! }
  end

  def do_get(page)
    get '/api/v1/members', headers: { 'HTTP_AUTHORIZATION' => valid_token },
          params: { page: page },
          # env: { 'action_dispatch.custom' => 'custom' },
          xhr: true, as: :json
    puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'valid token responds with all members' do
    body = do_get(2)
    expect(response).to be_success
    expect(response.status).to eq(200)
    expect(body.length).to eq(Member.count)
  end
  
end