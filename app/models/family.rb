class Family < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :memories, through: :pets
  has_many :user_families
  has_many :users, through: :user_families
  validates :name, presence: true
end
