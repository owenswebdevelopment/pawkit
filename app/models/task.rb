class Task < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validate :title, presence: true
  validate :due_date, presence: true
  validate :description, presence: true
end
