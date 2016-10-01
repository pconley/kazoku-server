require "rails_helper"

RSpec.describe Profile, :type => :model do

 	it "can create" do
		p = Profile.new() 
		expect(p).to_not be(nil)
	end

end