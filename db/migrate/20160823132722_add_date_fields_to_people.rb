class AddDateFieldsToPeople < ActiveRecord::Migration[5.0]
  def change
    
    add_column    :people, :birth_year, :integer
    add_column    :people, :birth_month, :integer
    add_column    :people, :birth_day, :integer
    remove_column :people, :birth_date, :date
    remove_column :people, :birth_date_string, :string
    
    add_column    :people, :death_year, :integer
    add_column    :people, :death_month, :integer
    add_column    :people, :death_day, :integer
    remove_column :people, :death_date, :date
    remove_column :people, :death_date_string, :string
    
  end
end
