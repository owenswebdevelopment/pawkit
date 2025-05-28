class Pet < ApplicationRecord
  belongs_to :family
  has_many :tasks
  has_many :memories
  has_many :medical_records
  has_many :users, through: :tasks
  has_one_attached :photo
  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :species, presence: true
  validates :birthdate, presence: true
end
