require 'rails_helper'

RSpec.describe Member, type: :model do

  	it "can create" do
		p = Member.create() 
		expect(p).to_not be(nil)
	end

 	it "has family" do
		kid = Member.create() 
		mom = Member.create(first_name: 'mom')
		dad = Member.create(first_name: 'dad')
		f = Family.create(name: 'rents', children:[kid], members: [mom,dad] )
		puts "f = #{f.inspect}"
		expect(kid.family.id).to eq(f.id)
		expect(kid.parents).to eq([mom,dad])
	end

end
