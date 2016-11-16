require 'rails_helper'

describe "API Members Paging", :type => :request do

  include ApiHelper

  before :each do
    (0..100).each { |n| Member.create! }
  end

  def do_get(page, size=nil)
    args = { page: page }
    args[:size] = size if size
    api_get "members", args
    expect(response).to be_success
    expect(response.status).to eq(200)
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'two responds with a page' do
    body = do_get(2)
    default_page_size = 20
    expect(body.length).to eq(default_page_size)
  end

  it 'two responds with a custom page' do
    custom_page_size = 25
    body = do_get(2, custom_page_size)
    expect(body.length).to eq(custom_page_size)
  end

  it 'big number responds with no page' do
    body = do_get(200)
    expect(body.length).to eq(0)
  end
  
end