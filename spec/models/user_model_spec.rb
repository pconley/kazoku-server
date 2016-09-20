require "rails_helper"

RSpec.describe User, :type => :model do
  it "can create users" do
    a = User.create!(email: 'a@a.a', password: 'password')
    b = User.create!(email: 'b@b.b', password: 'password')

    expect(User.count).to eq(2)
  end
end