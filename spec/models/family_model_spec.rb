require 'rails_helper'

RSpec.describe Family, type: :model do

  	it "can create" do
		f = Family.create() 
		expect(f).to_not be(nil)
	end

 	it "has members" do
		kid = Member.create() 
		mom = Member.create(first_name: 'mom')
		dad = Member.create(first_name: 'dad')
		f = Family.create(name: 'nuclear', children:[kid], members: [mom,dad] )
		puts "f = #{f.inspect}"
		expect(kid.family.id).to eq(f.id)
		expect(kid.parents).to eq([mom,dad])
		expect(mom.children).to eq([kid])
		expect(dad.children).to eq([kid])
	end

end
