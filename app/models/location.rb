class Location < ApplicationRecord
  validates :name, presence: true
  validates :category, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :email, presence: true
end
