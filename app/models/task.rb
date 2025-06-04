class Task < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  belongs_to :completed_by, class_name: 'User', optional: true
  validates :title, presence: true
  validates :due_date, presence: true
  after_create_commit :broadcast_task
  after_update_commit :recurring_task
  after_update_commit :message_memory


  def broadcast_task
    broadcast_append_to "family_#{pet.family.id}_tasks",
                          partial: "tasks/task",
                          target: "incomplete-tasks",
                          locals: {task: self, family: pet.family, tasks: pet.family.tasks}
  end

  def recurring_task
    RecurringTasksJob.new(self).perform if completed?
  end

  def message_memory
    Memory.create!(
      text: "A new task was created: #{title}",
      user: user,
      family: pet.family
    )
  end
end
