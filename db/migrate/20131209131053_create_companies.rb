class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :name
      t.text :address
      t.text :city
      t.text :country
      t.text :e-mail
      t.integer :phone

      t.timestamps
    end
  end
end
