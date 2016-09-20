require "rails_helper"

RSpec.describe MembersController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the person into @members" do
      m1, m2 = Person.create!, Person.create!
      get :index

      expect(assigns(:people)).to match_array([m1, m2])
    end
  end
end