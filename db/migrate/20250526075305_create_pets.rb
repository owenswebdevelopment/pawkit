class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :breed
      t.string :color
      t.date :birthdate
      t.boolean :neutered
      t.float :lat
      t.float :lon
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
