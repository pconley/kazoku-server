require 'json'

namespace :db do
  
  desc "Import Families from JSON file"
  
  task families: :environment do
           
    Person.delete_all 
    Family.delete_all
    Membership.delete_all

    count = 0
    
    File.open("#{Rails.root}/lib/tasks/fams1.json") do |f|
      
      until f.eof?
        temp = JSON.parse(f.readline)
        hash = Hash[temp.map{ |k, v| [k.to_sym, v] }]
        
        husb = Member.where(key: hash[:husb_key]).first
        puts "*** Husband: #{husb}"
        wife = Member.where(key: hash[:wife_key]).first
        puts "*** Wife   : #{wife}"
        
        puts "family key = #{hash[:key]}"
        kids = Member.where(famc_key: hash[:key]).all.to_a
        puts "kids = #{kids.count}"
        
        
        peeps = []
        peeps.push(husb) if husb
        peeps.push(wife) if wife
        params = {key: hash[:key], members: peeps, children: kids}
        
        count += 1
        fam = Family.create!(params)
        
        puts "#{count}: #{fam}"
        #break if count > 20
      end
      
    end
     
  end

end
