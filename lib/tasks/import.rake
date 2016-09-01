require 'json'

namespace :db do
  
  desc "Import People from JSON file"
  
  task import: :environment do
            
    Person.delete_all

    count = 0
    
    File.open("#{Rails.root}/lib/tasks/indi1.json") do |f|
      
      until f.eof?
        json = JSON.parse(f.readline)
        hash = Hash[json.map{ |k, v| [k.to_sym, v] }]
        params = hash.slice(:key, 
          :last_name, :first_name,:email,:gender,
          :birth_day,:birth_month,:birth_year,:birth_place,
          :death_day,:death_month,:death_year,:death_place,
          :buried_date,:buried_date_string,:buried_place,
          :famc_key,:fams_keys,:rawtext
        )
        
        params[:search_text] = Person.build_search_text(params)
        
        count += 1
        p = Person.create!(params)
        puts "#{count}: #{p}"
        
        #break if count > 20
      end
      
    end
     
  end

end
