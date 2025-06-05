class Pet < ApplicationRecord
  belongs_to :family
  has_many :tasks, dependent: :destroy
  has_many :medical_records, dependent: :destroy
  has_many :users, through: :tasks
  has_one_attached :photo
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integers: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  validates :gender, presence: true, inclusion: { in: %w(male female) }
  validates :species, presence: true
  validates :birthdate, presence: true

end
