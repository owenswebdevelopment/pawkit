class Location < ApplicationRecord
  validates :name, presence: true
  validates :category, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  geocoded_by :address,
              latitude: :lat,
              longitude: :lon
  after_validation :geocode, if: :will_save_change_to_address?
end
