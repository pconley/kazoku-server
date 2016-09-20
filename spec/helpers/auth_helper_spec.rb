require 'rails_helper'

RSpec.describe AuthHelper, :type => :helper do

	# helper is an instance of ActionView::Base configured with the
    # EventsHelper and all of Rails' built-in helpers

    invalid_token = "xxx"

    expired_token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2them9rdS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NTdkODA5OTU4Mzc0OTRhYjA2ODQ3NDNjIiwiYXVkIjoiNlZ0TldtU05YVnhMREN4aURRYUU2eEdiQkFiczROa2siLCJleHAiOjE0NzQzNjk1ODMsImlhdCI6MTQ3NDMzMzU4M30.jgDdLsjF3yoK5vFC1_IK-6EtkbLuufrkaolkrtbmvm8'

  	describe "#get_auth0_profile" do
   #  	it "fails on nil token" do
			# expect(helper.get_auth0_profile(nil)).to eq(false)
   #  	end
     	it "throws on nill token" do
			expect { helper.get_auth0_profile(nil) }.to raise_error(InvalidTokenError)
    	end
     	it "throws on invalid token" do
			expect { helper.get_auth0_profile(invalid_token) }.to raise_error(JWT::DecodeError)
    	end
    	it "throws on invalid token" do
			expect { helper.get_auth0_profile(expired_token) }.to raise_error(JWT::ExpiredSignature)
    	end
   	end

end