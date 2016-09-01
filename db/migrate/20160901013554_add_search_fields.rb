class AddSearchFields < ActiveRecord::Migration[5.0]
  def change
    add_column :families, :search_text, :citext
    add_column :people, :search_text, :citext
    add_column :people, :middle_name, :string
    add_column :people, :common_name, :string 
  end
end
