class TasksController < ApplicationController

    def index
        @family = Family.find(params[:family_id])   
        @tasks = @family.tasks #array of tasks of pet     
        @task = Task.new

    end

    def create
        @task = Task.new(task_params)
        @task.user = current_user
        @task.pet = Pet.find( params[:task][:pet]) 
        if @task.save
            redirect_to family_tasks_path, notice: 'Saved Successfully'
        else 
            render "families/:id/tasks", status: :unprocessable_entity
        end
    end

    def update
        @task = Task.find(params[:id])
        @task.update(task_params)
        respond_to do |format|
            format.html { redirect_to family_tasks_path(@task.pet.family), notice: "Completed" }
            format.turbo_stream
         end
    end


    private

    def task_params
        params.require(:task).permit(:description, :due_date, :title, :completed, :pet_id)
    end
end
