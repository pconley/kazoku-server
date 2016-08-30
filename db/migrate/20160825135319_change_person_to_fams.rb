class ChangePersonToFams < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :fams_key, :string
       add_column :people, :fams_keys, :string
  end
end
