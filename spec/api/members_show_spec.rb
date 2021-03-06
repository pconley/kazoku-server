require 'rails_helper'

describe "API Members::show", :type => :request do

  include ApiHelper 
  include AuthHelper # example tokens

  before :each do
    @mem = Member.create!(first_name: 'mem')
    # note the sibling birth years are out of order!!!
    b1 = Event.create!({ kind: 'birth', year: 1960})
    b2 = Event.create!({ kind: 'birth', year: 1955})
    b3 = Event.create!({ kind: 'birth', year: 1950})
    @sib1 = Member.create!(first_name: 'sib1', events: [b1])
    @sib2 = Member.create!(first_name: 'sib2', events: [b2])
    @sib3 = Member.create!(first_name: 'sib3', events: [b3])
    @mom = Member.create!(first_name: 'mom')
    @dad = Member.create!(first_name: 'dad')
    @spouse1 = Member.create!(first_name: 'spouse')
    @child1_1 = Member.create!(first_name: 'junior')
    @child1_2 = Member.create!(first_name: 'princess')
    @spouse2 = Member.create!(first_name: 'spouse2')
    @child2_1 = Member.create!(first_name: 'lil surprise')
    fam0 = Family.create!(name: 'parents family', members: [@mom,@dad], children: [@mem,@sib1,@sib2,@sib3])
    fam1 = Family.create!(name: 'members first', members: [@mem,@spouse1], children: [@child1_1,@child1_2])
    fam2 = Family.create!(name: 'members second', members: [@mem,@spouse2], children: [@child2_1])
  end

  def do_show(id,token)
    api_get "members/#{id}", {}, token
    # puts "+++ response = #{response.status} :: #{response.body[0..2000]}"
    return JSON.parse(response.body)
  end

  it 'missing token responds with error' do
    body = do_show(@mem.id,nil)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("missing token")
  end

  it 'expired token responds with error' do
    body = do_show(@mem.id,expired_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'invalid token responds with error' do
    body = do_show(@mem.id,invalid_token)
    expect(response).to_not be_success
    expect(response.status).to eq(401)
    expect(body['errors'].first).to eq("invalid token")
  end

  it 'valid token responds with details' do
    member_hash = do_show(@mem.id,valid_token)
    expect(response).to be_success
    expect(response.status).to eq(200)
    expect(member_hash['first_name']).to eq(@mem.first_name)
    parents = member_hash['parents']
    expect(parents.length).to eq(2)
    expect(parents[0]['first_name']).to eq(@mom.first_name)
    expect(parents[1]['first_name']).to eq(@dad.first_name)
    children = member_hash['children']
    expect(children.length).to eq(3)
    expect(children[0]['first_name']).to eq(@child1_1.first_name)
    expect(children[1]['first_name']).to eq(@child1_2.first_name)
    expect(children[2]['first_name']).to eq(@child2_1.first_name)
    siblings = member_hash['siblings']
    expect(siblings.length).to eq(3)
    # expect them to be in birth year order
    expect(siblings[0]['first_name']).to eq(@sib3.first_name)
    expect(siblings[1]['first_name']).to eq(@sib2.first_name)
    expect(siblings[2]['first_name']).to eq(@sib1.first_name)
    spouses = member_hash['spouses']
    expect(spouses.length).to eq(2)
    expect(spouses[0]['first_name']).to eq(@spouse1.first_name)
    expect(spouses[1]['first_name']).to eq(@spouse2.first_name)
  end
  
end