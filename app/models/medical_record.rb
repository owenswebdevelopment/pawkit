class MedicalRecord < ApplicationRecord
  belongs_to :pet
  belongs_to :location, optional: true
  validates :diagnosis, presence: true
  validates :notes, presence: true
  validates :visit_date, presence: true
  validates :treatment, presence: true

  def medical_memory(user)
    Memory.create(
      text: "New medical record of #{pet.name}
      Diagnosis: #{diagnosis.capitalize}
      Notes: #{notes.capitalize}
      Treatment: #{treatment.capitalize}
      Visit Date: #{visit_date}",
      user: user,
      family: pet.family
    )
  end

end
