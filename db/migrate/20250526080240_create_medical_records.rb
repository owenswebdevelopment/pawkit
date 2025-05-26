class CreateMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_records do |t|
      t.string :diagnosis
      t.string :notes
      t.date :visit_date
      t.string :treatmeant
      t.string :vaccination_status
      t.string :insurance_status
      t.references :pet, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
