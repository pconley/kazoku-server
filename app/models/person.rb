class Person < ApplicationRecord
  
  def to_s
    "<Person #{key} #{last_name}, #{first_name}>"
  end
  
end
