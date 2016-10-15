require 'rails_helper'

RSpec.describe Member, type: :model do

	params = {
		kind: 'graduation',
		place: 'penn state',
		state: 'PA', country: 'USA',
		description: 'best 6 years of my life'
	}

  	it "can create" do
		e = Event.create!() 
		expect(e).to_not be(nil)
	end

  	it "has date attributes" do
		e = Event.create!({year: 1955, month: 3, day: 7}) 
		expect(e.year).to eq(1955)
		expect(e.month).to eq(3)
		expect(e.day).to eq(7)

		expect(e.date_string).to include("7")
		expect(e.date_string).to include("3")
		expect(e.date_string).to include("1955")
	end

  	it "has other attributes" do
		e = Event.create!(params) 
		expect(e.kind).to eq(params[:kind])
		expect(e.place).to eq(params[:place])
		expect(e.state).to eq(params[:state])
		expect(e.country).to eq(params[:country])
		expect(e.description).to eq(params[:description])
	end

 	it "belongs to a member" do
		m = Member.create!() 
		e = m.events.create!()
		expect(e).to_not be(nil)
		expect(e.member.id).to eq(m.id)
		expect(m.events.count).to eq(1)
		expect(m.events[0].id).to eq(e.id)
	end

end
