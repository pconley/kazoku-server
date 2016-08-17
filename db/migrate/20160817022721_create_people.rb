class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      
      t.date   :birth_date
      t.string :birth_date_string
      t.string :birth_place
      
      t.date   :death_date
      t.string :death_date_string
      t.string :death_place
      
      t.date   :buried_date
      t.string :buried_date_string
      t.string :buried_place
      
      t.string :key
      t.string :famc_key
      t.string :fams_key
      
      t.timestamps
    end
  end
end
