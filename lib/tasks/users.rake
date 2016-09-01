namespace :db do
  
  desc "add users to system"
  
  task users: :environment do
    
    User.delete_all
    
    User.create!({email: 'pat@conley.com', password: 'Altoona2016'})
    User.create!({email: 'mike@conley.com', password: 'Altoona2016'})
    User.create!({email: 'donna@conley.com', password: 'Altoona2016'})
  end

end
