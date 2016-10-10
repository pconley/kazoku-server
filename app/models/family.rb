class Family < ApplicationRecord
  
  belongs_to :wife, class_name: 'Person', optional: true
  belongs_to :husband, class_name: 'Person', optional: true
  
  has_many :children, class_name: 'Person', foreign_key: "family_id"
  
  has_many :memberships
  has_many :people, through: :memberships
  
  def to_s
    "<Family##{id} #{key} #{name}>"
  end
  
  def display_name
    name ? name : built_name
  end
  
  def built_name
    name = people[0] ? people[0].first_name : ''
    name += ' & ' if name.length > 0 && people[1]
    name += people[1].first_name if people[1]
    return name
  end
  
end
