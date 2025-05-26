class Memory < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validates :text
  has_many :media
end
