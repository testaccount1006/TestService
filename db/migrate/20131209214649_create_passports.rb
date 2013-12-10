class CreatePassports < ActiveRecord::Migration
  def change
    create_table :passports do |t|
      t.integer :person_id
      t.binary :passport
      t.text :description

      t.timestamps
    end
  end
end
