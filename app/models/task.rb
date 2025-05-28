class Task < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  validates :title, presence: true
  validates :due_date, presence: true
  validates :description, presence: true
  after_create_commit :broadcast_task

  def broadcast_task
    broadcast_append_to "family_#{pet.family.id}_tasks",
                          partial: "tasks/task",
                          target: "incomplete-tasks",
                          locals: {task: self, family: pet.family, tasks: pet.family.tasks}
  end
end
