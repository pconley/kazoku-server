class CreateFamilies < ActiveRecord::Migration[5.0]
  def change
    create_table :families do |t|
      t.string :name
      t.string :key
      t.string :husb_key
      t.string :wife_key
      
      t.integer :wife_id, null: true
      t.integer :husband_id, null: true

      t.timestamps
    end
    
    add_reference :people, :family, foreign_key: true
    
    create_table :memberships do |t|
      t.string     :role # child; husband; wife
      t.belongs_to :person, index: true
      t.belongs_to :family, index: true
    end
    
  end
end
