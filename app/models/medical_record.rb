class MedicalRecord < ApplicationRecord
  belongs_to :pet
  belongs_to :location
  validates :diagnosis, presence: true
  validates :notes, presence: true
  validates :visit_date, presence: true
  validates :treatment, presence: true
end
