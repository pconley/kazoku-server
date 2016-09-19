class AddSubToUser < ActiveRecord::Migration[5.0]
  def change

  	    add_column :users, :sub, :string 
  	    add_column :users, :first_access_at, :datetime
  	    add_column :users, :last_access_at, :datetime
  	    add_column :users, :access_count, :integer, default: 0, null: false

  	    add_index :users, :sub, unique: true
  end
end
