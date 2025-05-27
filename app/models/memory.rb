class Memory < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validates :text, presence:true 
  has_many :media
end
