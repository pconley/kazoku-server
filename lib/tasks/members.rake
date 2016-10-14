require 'json'

 def add_event(member,kind,place,year,month,day)
 	if( year!=0 && place!="" )
  		params = { kind: kind, place: place, year: year, month: month, day: day }
    	member.events.create(params)
    	member.save!
    	# puts "--- #{member.events.last}"
    	if( kind==:buried )
    		puts "buried: #{member}"
    	end
    end
  end

namespace :db do

   
  desc "Import Members from JSON file"
  
  task members: :environment do
            
    Member.delete_all

    count = 0
    
    File.open("#{Rails.root}/lib/tasks/indi1.json") do |f|
      
      until f.eof?
        json = JSON.parse(f.readline)
        hash = Hash[json.map{ |k, v| [k.to_sym, v] }]
        params = hash.slice(:key, 
          :last_name, :first_name,:email,:gender,
          :famc_key,:fams_keys,:rawtext
        )
        
        params[:search_text] = Member.build_search_text(params)
        
        count += 1
        member = Member.create!(params)
        puts "#{count}: #{member}"

        puts "#{hash[:burried_place]}"


        add_event(member, :birth, hash[:birth_place],hash[:birth_year], hash[:birth_month],hash[:birth_day])
        add_event(member, :death, hash[:death_place],hash[:death_year], hash[:death_month],hash[:death_day])
        # add_event(member, :buried, hash[:burried_place],0,0,0)
     	# NEEDS WORK:    :buried_date,:buried_date_string,:buried_place,

        #break if count > 20
      end
      
    end
     
  end

end
