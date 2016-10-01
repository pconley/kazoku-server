require "rails_helper"

# NOTE: redis need to be running for caching to be working

RSpec.describe ProfileService, :type => :model do

	include AuthHelper # example tokens

    before(:each) do
		CacheService.clear # remove all cached data
  	end

 	it "fails on nill token" do
		p = ProfileService.find(nil) 
		expect(p).to be(nil)
	end

 	it "fails on invalid token" do
		p = ProfileService.find(invalid_token) 
		expect(p).to be(nil)
	end

 	it "fails on expired token" do
		p = ProfileService.find(expired_token) 
		expect(p).to be(nil)
	end

 	it "works with a valid token" do
		p = ProfileService.find(valid_token) 
		puts "+++ p = #{p}"
		expect(p.role).to eq("user")
		expect(p.name).to eq("pat1")
		expect(p.email).to eq("pat1@conley.com")
	end

end