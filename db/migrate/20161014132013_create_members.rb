class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :common_name
      t.string :gender
      t.string :key
      t.string :famc_key
      t.string :fams_keys
      t.string :email
      t.string :rawtext
      t.string :search_text
      t.integer :family_id

      t.timestamps

      t.index [:family_id], name: :index_member_on_family_id
      
    end

    create_table :events do |t|

      t.string :kind
      t.integer :year
      t.integer :month
      t.integer :day
      t.string :date_string
      t.string :place
      t.string :state
      t.string :country
      t.string :description
      t.string :search_text
      t.integer :member_id  

      t.timestamps

      t.index [:member_id], name: :index_event_on_member_id
      
    end

    remove_column :memberships, :person_id, :integer
       add_column :memberships, :member_id, :integer

  end
end


