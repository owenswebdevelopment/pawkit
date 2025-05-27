class Pet < ApplicationRecord
  belongs_to :family
  has_many :tasks
  has_many :memories
  has_many :medical_records
  has_many :users, through: :tasks
  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :breed, presence: true
  validates :birthdate, presence: true
end
