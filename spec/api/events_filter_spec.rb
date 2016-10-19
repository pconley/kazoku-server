require 'rails_helper'

describe "API Events Paging", :type => :request do

  include ApiHelper

  before :each do
    (1..12).each { |m| Event.create!(kind: 'exam', year: 2014, month: m, day: 7 ) }
    (1..12).each { |m| Event.create!(kind: 'test', year: 2015, month: m, day: 14 ) }
    puts "count = #{Event.count}"
  end

  def do_get(args)
    api_get 'events', args
    puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    expect(response).to be_success
    expect(response.status).to eq(200)
    return JSON.parse(response.body)
  end

  it 'gets events for the month' do
    body = do_get({month: 2})
    expect(body.length).to eq(2)
  end

  it 'gets events for the year' do
    body = do_get({year: 2014})
    expect(body.length).to eq(12)
  end

  it 'gets events for the day' do
    body = do_get({day: 14})
    expect(body.length).to eq(12)
  end

  it 'gets events for the month and year' do
    body = do_get({year: 2014, month: 3})
    expect(body.length).to eq(1)
  end
  
end