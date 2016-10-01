require "rails_helper"

RSpec.describe CacheService, :type => :model do

    before(:each) do
		CacheService.clear
  	end

 	it "saves a profile" do
		CacheService.save_profile('key1','data1')
		profile1 = CacheService.get_profile('key1')
		expect(profile1).to eq('data1')
	end

end