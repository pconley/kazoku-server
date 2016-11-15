class Event < ApplicationRecord

  	belongs_to :member, optional: true

    scope :births, -> { where("kind='birth'") }
    scope :deaths, -> { where("kind='death'") }

    scope :for_day,   -> (d) { where(day:   d) }
    scope :for_month, -> (m) { where(month: m) }
    scope :for_year,  -> (y) { where(year:  y) }

    scope :on_anniversary, -> (m,d) { for_month(m).for_day(d) }

    scope :on_date, -> (dt) { for_month(dt.month).for_day(dt.day).for_year(dt.year) }

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