require 'rails_helper'

RSpec.describe Event, type: :model do

	before :each do
    	(0..12).each do |m| 
    		puts m
    		Event.create!({month: m, kind: "birth"})
    		Event.create!({month: m, kind: "death"})
    		Event.create!({month: m, kind: "graduation"})
    	end
    	puts "count = #{Event.count}"
  	end

  	it "can retrieve births" do
		set = Event.births.all
		expect(set.count).to eq(12)
	end

end
