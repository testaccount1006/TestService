class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.text :name
      t.text :title
      t.integer :company_id

      t.timestamps
    end
  end
end
