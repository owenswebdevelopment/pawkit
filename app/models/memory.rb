class Memory < ApplicationRecord
  belongs_to :family
  belongs_to :user
  validates :text, presence: true
  has_many_attached :media
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "family_#{family.id}_memories",
                        partial: "memories/memory",
                        target: "memories",
                        locals: { memory: self, current_user_id: user.id }
  end
end
