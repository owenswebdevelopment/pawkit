class Memory < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validates :text, presence: true
  has_many :media

  private

  def broadcast_message
    broadcast_append_to "family_#{pet.family.id}_memories",
                        partial: "memories/memory",
                        target: "memories",
                        locals: { memories: self }
  end
end
