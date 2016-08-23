class Person < ApplicationRecord
  
  def to_s
    "<Person #{key} #{last_name}, #{first_name}>"
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
