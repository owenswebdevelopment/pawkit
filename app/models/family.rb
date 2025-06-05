class Family < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :tasks, through: :pets
  has_many :memories
  has_many :user_families
  has_many :users, through: :user_families
  validates :name, presence: true
  has_one_attached :photo

  before_create :generate_invite_token

  private

  def generate_invite_token
    self.invite_token = SecureRandom.hex(10)
  end
end
