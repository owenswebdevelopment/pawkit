class AddCompletedByToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :completed_by, foreign_key: {to_table: :users }
  end
end
