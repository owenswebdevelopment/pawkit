class TasksController < ApplicationController

    def index
        @family = Family.find(params[:family_id])
        @tasks = @family.tasks.order(:due_date) #array of tasks of pet
        @task = Task.new
        # @daily_tasks = Task.where(recurrence: "daily").order(:due_date)
        # @weeky_tasks = Task.where(recurrence: "weekly").order(:due_date)
        # @monthly_tasks = Task.where(recurrence: "monthly").order(:due_date)




    end

    def create
        @task = Task.new(task_params)
        @task.user = current_user
        @task.pet = Pet.find(params[:task][:pet_id])

        if @task.save
            redirect_to request.referer, notice: 'Saved Successfully'
        else
            render "families/:id", status: :unprocessable_entity
        end
    end

    def update
        @task = Task.find(params[:id])
        @task.completed_by = current_user
        @task.update(task_params)

        respond_to do |format|
            format.html { redirect_to request.referer, notice: "completed the task!" }
            format.turbo_stream
         end
    end


    private

    def task_params
      params.require(:task).permit(:description, :due_date, :title, :completed, :completed_by, :recurrence, :pet_id)
    end
end
