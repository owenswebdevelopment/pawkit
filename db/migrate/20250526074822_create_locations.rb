class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :category
      t.string :address
      t.integer :phone
      t.string :email

      t.timestamps
    end
  end
end
