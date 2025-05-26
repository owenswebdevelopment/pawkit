class CreateUserFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :user_families do |t|
      t.references :family, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
