require "rails_helper"

RSpec.describe AuthService, :type => :model do

	include AuthHelper # example tokens

    before(:each) do
  	end

  	it "can extract the subscriber" do
  		sub = AuthService.extract_subscriber(valid_token)
  		expect(sub).to eq('auth0|57d226d9a164af8c3bee2bee')
  	end

 	it "fetches a profile" do
		json = AuthService.fetch_profile(valid_token)
		expect(json.length).to be > 50
		profile = JSON.parse(json)
		expect(profile['email']).to eq("pat1@conley.com")
	end

end