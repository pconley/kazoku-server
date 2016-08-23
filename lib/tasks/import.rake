require 'json'

namespace :db do
  
  desc "Import People from JSON file"
  
  task import: :environment do
            
    Person.delete_all

    count = 0
    
    File.open("#{Rails.root}/lib/tasks/indi1.json") do |f|
      
      until f.eof?
        my_hash = JSON.parse(f.readline)
        sy_hash = Hash[my_hash.map{ |k, v| [k.to_sym, v] }]
        xx_hash = sy_hash.slice(:key, 
          :last_name, :first_name,:email,:gender,
          :birth_day,:birth_month,:birth_year,:birth_place,
          :death_day,:death_month,:death_year,:death_place,
          :buried_date,:buried_date_string,:buried_place,
          :famc_key,:fams_key
        )
        
        count += 1
        p = Person.create(xx_hash)
        puts "#{count}: #{p}"
        
        break if count > 20
      end
      
    end
     
  end

end
