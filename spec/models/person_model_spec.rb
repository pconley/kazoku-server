require "rails_helper"

RSpec.describe Person, :type => :model do

 	it "can create" do
		p = Person.create() 
		expect(p).to_not be(nil)
	end

 	it "has family" do
		p = Person.create() 
		mom = Person.create(first_name: 'mom')
		dad = Person.create(first_name: 'dad')
		f = Family.create(name: 'rents', wife: mom, husband: dad, children: [p])
		puts "f = #{f.inspect}"
		expect(p.family.id).to eq(f.id)
		expect(p.parents).to eq([mom,dad])
	end

end