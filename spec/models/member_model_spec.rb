require 'rails_helper'

RSpec.describe Member, type: :model do

  	it "can create" do
		p = Member.create() 
		expect(p).to_not be(nil)
	end

 	it "has complex family" do
		mem = Member.create(first_name: 'mike') 
		sib = Member.create(first_name: 'pat') 
		sp1 = Member.create(first_name: 'michele') 
		sp2 = Member.create(first_name: 'margeret')
		k1 = Member.create(first_name: 'sugar') 
		k2 = Member.create(first_name: 'spice') 
		mom = Member.create(first_name: 'mom')
		dad = Member.create(first_name: 'dad')
		fam = Family.create(name: 'parents family', children:[mem,sib], members: [mom,dad] )
		mg1 = Family.create(name: 'first marraige', members: [mem,sp1] )
		mg2 = Family.create(name: 'second marraige', members: [mem,sp2], children: [k1,k2] )
		puts "family = #{fam.inspect}"
		expect(mem.family.id).to eq(fam.id)
		expect(mem.parents).to eq([mom,dad])
		expect(mem.siblings.length).to eq(1) # not include self
		expect(mem.siblings).to eq([sib])
		expect(mem.spouses.length).to eq(2)
		expect(mem.spouses).to eq([sp1,sp2])
		expect(mem.children.length).to eq(2)
		expect(mem.children).to eq([k1,k2])
	end

end
