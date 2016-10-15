require 'rails_helper'

describe "API Members::show", :type => :request do

  include AuthHelper # example tokens

  before :each do
    @p1 = Member.create!(first_name: 'p1', )
    @p2 = Member.create!(first_name: 'p2', )
 
    @mom = Member.create!(first_name: 'mom')
    @dad = Member.create!(first_name: 'dad')

    fam = Family.create!(name: 'fam1', members: [@mom,@dad], children: [@p1,@p2])

  end

  def do_show(id,token)
    get "/api/v1/members/#{id}", headers: { 'HTTP_AUTHORIZATION' => token },
          # params: { id: id },
          # env: { 'action_dispatch.custom' => 'custom' },
          xhr: true, as: :json
    puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'missing token responds with error' do
    body = do_show(@p1.id,nil)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("missing token")
  end

  it 'expired token responds with error' do
    body = do_show(@p1.id,expired_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'invalid token responds with error' do
    body = do_show(@p1.id,invalid_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'valid token responds with details' do
    member_hash = do_show(@p1.id,valid_token)
    expect(response).to be_success
    expect(response.status).to eq(200)
    expect(member_hash['first_name']).to eq(@p1.first_name)
    parents = member_hash['parents']
    expect(parents.length).to eq(2)
    expect(parents[0]['first_name']).to eq(@mom.first_name)
    expect(parents[1]['first_name']).to eq(@dad.first_name)
  end
  
end