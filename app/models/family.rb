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
    name = member[0] ? member[0].first_name : ''
    name += ' & ' if name.length > 0 && member[1]
    name += member[1].first_name if member[1]
    return name
  end
  
end
