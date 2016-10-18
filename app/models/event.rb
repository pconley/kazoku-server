class Event < ApplicationRecord

  	belongs_to :member, optional: true

    scope :births, -> { where('kind="birth" and month>0') }
    scope :deaths, -> { where('kind="death" and month>0') }

    scope :for_month, lambda{|m| { :conditions => { month: m } } }

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