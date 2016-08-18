namespace :db do
  
  desc "add users to system"
  
  task add_users: :environment do
    u1 = User.create!({email: 'p@p.p', password: 'password'})
  end

end
