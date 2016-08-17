class Person < ApplicationRecord
  
  def to_s
    "<Person #{old_key} #{last_name}, #{first_name}>"
  end
  
end
