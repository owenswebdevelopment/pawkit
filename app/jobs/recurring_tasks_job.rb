class RecurringTasksJob < ApplicationJob
    def initialize(task)
        @recurring_task = task.dup
        @recurring_task.completed = false
    end

    def perform
        case @recurring_task.recurrence
        when "daily" then @recurring_task.due_date = Date.today + 1.day
        when "monthly" then @recurring_task.due_date = Date.today +  1.month
        when "weekly" then @recurring_task.due_date = Date.today + 1.week
        end
        @recurring_task.save
    end
end
