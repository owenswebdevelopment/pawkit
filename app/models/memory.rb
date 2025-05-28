class Memory < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validates :text, presence: true
  has_many_attached :media
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "family_#{pet.family.id}_memories",
                        partial: "memories/memory",
                        target: "memories",
                        locals: { memory: self }
  end
end
