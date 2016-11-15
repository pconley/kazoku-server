require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:count) {12}

  let(:year) {2014}

	before :each do
    d = 1
    (0..count).each do |m| 
    		Event.create!({day: d, month: m, year: year, kind: "birth"})
    		Event.create!({day: d, month: m, year: year, kind: "death"})
    		Event.create!({day: d, month: m, year: year, kind: "graduation"})
        d += 1
    end
  end

  it "can retrieve births" do
    set = Event.births.all
    # not does not include the zero
    expect(set.count).to eq(count+1)
  end

  it "can retrieve deaths" do
    set = Event.deaths.all
    # not does not include the zero
    expect(set.count).to eq(count+1)
  end

  it "can retrieve by month" do
    set = Event.for_month(5).all
    # not does not include the zero
    expect(set.count).to eq(3)
  end

  it "can retrieve by day" do
    set = Event.for_day(1).all
    expect(set.count).to eq(3)
  end

  it "can retrieve for anniversary" do
    # Feburary 2nd
    set = Event.on_anniversary(2,3).all
    expect(set.count).to eq(3)
  end

  it "can retrieve specific date" do
    set = Event.on_date(Date.new(year,4,5)).all
    expect(set.count).to eq(3)
  end

end
