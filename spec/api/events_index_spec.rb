require 'rails_helper'

describe "API Events", :type => :request do

  include ApiHelper 
  include AuthHelper # example tokens

  before :each do
    m = Member.create!(last_name: "last", first_name: "first")
    Event.create!(member: m, kind:'birth', year: 1955, month: 3, day: 1 )
    Event.create!(member: m, kind:'death', year: 2025, month: 8, day: 5 )
  end

  def do_get(token)
    api_get "events", {}, token
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
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