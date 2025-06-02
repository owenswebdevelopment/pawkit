class ChangeLocationIdInMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    change_column :medical_records, :location_id, :bigint, null: true
  end
end
