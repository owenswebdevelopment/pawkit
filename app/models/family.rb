class Family < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :users, through: :user_families
  validates :name, presence: true
end
