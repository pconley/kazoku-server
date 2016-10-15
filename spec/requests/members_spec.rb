require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "GET /members" do
    it "works! (now write some real specs)" do
      get members_path
      expect(response).to have_http_status(302) # not authorized
    end
  end
end
