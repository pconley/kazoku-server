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
  
  	def full_name
    	"#{first_name} #{last_name}"
  	end

  	def birth_string
  		self.events.birth.date_string
  	end

    def parents
      family.members
    end

end
