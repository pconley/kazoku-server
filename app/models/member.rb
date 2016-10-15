class Member < ApplicationRecord

	# a member is a child of only one family
  belongs_to :family, optional: true
  
  # but, may be a member of several marraiges
  has_many :memberships
  has_many :families, through: :memberships

  # events like birth, death, marriage
  has_many :events

	def to_s
    "<Member##{id} #{key} #{last_name}, #{first_name}>"
  end

  def self.search(search)
    where("search_text LIKE ?", "%#{search}%") 
  end

	def self.build_search_text(params)
  	search_text = ''
  	search_text += params[:first_name].downcase + ' ' if params[:first_name]
  	search_text += params[:last_name].downcase  + ' ' if params[:last_name]
  	search_text += params[:birth_year].to_s + ' ' if params[:birth_year]
  	search_text += params[:death_year].to_s + ' ' if params[:death_year]
  	return search_text
  end

  def display_name
    "#{last_name}, #{first_name}"
  end

  def birth
    # there is only one birth!
    self.events.birth.first
  end

  def death
    # there is only one death!
    self.events.death.first
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def birth_string
    return '?' unless birth
    return '?' unless birth.year > 0
    return birth.year.to_s
  end

  def parents
    family.try :members
  end

  def display_dates
    return "(#{self.birth_string})" unless death && death.year > 0
    return "(#{self.birth_string} - #{death.year})"
  end

  def rawtexts
    rawtext.split("\r\n")
  end


end