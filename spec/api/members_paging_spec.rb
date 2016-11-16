require 'rails_helper'

describe "API Members Paging", :type => :request do

  include ApiHelper

  before :each do
    (0..40).each { |n| Member.create! }
  end

  def do_get(page)
    api_get "members", { page: page }
    expect(response).to be_success
    expect(response.status).to eq(200)
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'two responds with a page' do
    body = do_get(2)
    expect(body.length).to eq(20)
  end

  it 'big number responds with no page' do
    body = do_get(200)
    expect(body.length).to eq(0)
  end
  
end