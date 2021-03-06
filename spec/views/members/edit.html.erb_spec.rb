require 'rails_helper'

RSpec.describe "members/edit", type: :view do
  before(:each) do
    @member = assign(:member, Member.create!(
      :last_name => "MyString",
      :first_name => "MyString",
      :middle_name => "MyString",
      :common_name => "MyString",
      :gender => "MyString",
      :key => "MyString",
      :famc_key => "MyString",
      :fams_keys => "MyString"
    ))
  end

  it "renders the edit member form" do
    render

    assert_select "form[action=?][method=?]", member_path(@member), "post" do

      assert_select "input#member_last_name[name=?]", "member[last_name]"

      assert_select "input#member_first_name[name=?]", "member[first_name]"

      assert_select "input#member_middle_name[name=?]", "member[middle_name]"

      assert_select "input#member_common_name[name=?]", "member[common_name]"

      assert_select "input#member_gender[name=?]", "member[gender]"

      assert_select "input#member_key[name=?]", "member[key]"

      assert_select "input#member_famc_key[name=?]", "member[famc_key]"

      assert_select "input#member_fams_keys[name=?]", "member[fams_keys]"
    end
  end
end
