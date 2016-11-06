require 'rails_helper'

describe "API Events", :type => :request do

  include AuthHelper # example tokens

  before :each do
    m = Member.create!
    Event.create!(member: m)
    Event.create!
  end

  def do_get(token)
    get '/api/v1/events', headers: { 'HTTP_AUTHORIZATION' => token },
          # params: { id: 1 },
          # env: { 'action_dispatch.custom' => 'custom' },
          xhr: true, as: :json
    puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'missing token responds with error' do
    body = do_get(nil)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("missing token")
  end

  it 'expired token responds with error' do
    body = do_get(expired_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'invalid token responds with error' do
    body = do_get(invalid_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'valid token responds with all events' do
    body = do_get(valid_token)
    expect(response).to be_success
    expect(response.status).to eq(200)
    expect(body.length).to eq(Event.count)
  end
  
end