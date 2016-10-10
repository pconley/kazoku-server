class Person < ApplicationRecord
  
  # a person belongs to one family, that is... 
  # a person is a child of one and only one family
  belongs_to :family, optional: true
  
  has_many :memberships
  has_many :families, through: :memberships
  
  # has_many   :own_family, class_name: 'Family'
  
  def to_s
    "<Person##{id} #{key} #{last_name}, #{first_name}>"
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

  def parents
    result = []
    result << family.wife if family && family.wife
    result << family.husband if family && family.husband
    result
  end
  
  def description
    "#{full_name} #{display_dates}"
  end
  
  def display_name
    "#{last_name}, #{first_name}"
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def display_dates
    birth_string = birth_year == 0 ? '?' : birth_year.to_s
    death_year==0 ? "(#{birth_string})" : "(#{birth_string} - #{death_year})"
  end
   
  def rawtexts
    rawtext.split("\r\n")
  end
  
  def birth_date_string
    date_as_string(birth_day,birth_month,birth_year)
  end

  def death_date_string
    date_as_string(death_day,death_month,death_year)
  end
  
  def date_as_string(d,m,y) 
    x = d.to_i + m.to_i + y.to_i
    return "" if x == 0
    day = d > 0 ? "#{d}, " : ""
    "#{month_string(m)} #{day}#{y}" 
  end
  
  def month_string(m)
    case m.to_i
    when 0
      ""
    when 1
      "Jan"
    when 2
      "Feb"
    when 3
      "Mar"
    when 4
      "Apr"
    when 5
      "May"
    when 6
      "Jun"
    when 7
      "Jul"
    when 8
      "Aug"
    when 9
      "Sep"
    when 10
      "Oct"
    when 11
      "Nov"
    when 12
      "Dec"
    else
      "Err"
    end
  end
  
end
