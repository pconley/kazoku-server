class Event < ApplicationRecord

  	belongs_to :member, optional: true

    scope :birth, -> { where(kind: 'birth') }
    scope :death, -> { where(kind: 'death') }
  
	def to_s
    	"<Event##{id} #{kind} : #{year}-#{month}-#{day} at #{place}>"
  	end

  	def date_string
  		result = ""
  		result += "#{year}" if year > 0 
  		result += "-#{month}" if month > 0
  		result += "-#{day}" if day > 0
  		return result
   	end

end