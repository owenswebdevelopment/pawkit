class Family < ApplicationRecord
  has_many :pets
  has_many :users, through: :user_families
  validates :name, presence: true
end
