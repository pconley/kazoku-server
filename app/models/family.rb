class Family < ApplicationRecord
  
  # belongs_to :wife, class_name: 'Member', optional: true
  # belongs_to :husband, class_name: 'Member', optional: true
  
  has_many :children, class_name: 'Member', foreign_key: "family_id"
  
  has_many :memberships
  has_many :members, through: :memberships
  
  def to_s
    "<Family##{id} #{key} #{name}>"
  end
  
  def display_name
    name ? name : built_name
  end
  
  def built_name
    return "error1" unless members
    return "error2" unless members[0]
    name = members[0] ? members[0].first_name : ''
    name += ' & ' if name.length > 0 && members[1]
    name += members[1].first_name if members[1]
    return name
  end
  
end
