class RenameTreatmentToTreatmentInMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    rename_column :medical_records, :treatmeant, :treatment
  end
end
