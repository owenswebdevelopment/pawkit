class Location < ApplicationRecord
  validates :name, presence: true
  validates :place_id, presence: true, uniqueness: true

  # Optional fields → no validation required:
  # :category, :address, :phone, :email, :business_status, :rating, :user_ratings_total, :first_review

  # Geocoder:
  geocoded_by :address, latitude: :latitude, longitude: :longitude
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.will_save_change_to_address? }
end
