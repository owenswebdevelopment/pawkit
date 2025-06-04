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



    if @task.save
      redirect_to request.referer, notice: 'Saved Successfully'
    else
      render "families/show", status: :unprocessable_entity, notice: 'Save unsuccessful'

    end
  end

  def update
    @task = Task.find(params[:id])
    @task.completed_by = current_user
    @task.update(task_params)
    @task.message_memory
    # if task updated successfully and it is completed
    # Then create a memory and make a notice eg. notice: 'Save successful'
    # else
    # ... do something else with a notice that update failed

        send_line_notification("C493c98e6e0b758410091ac87570ec99d", @task.completed? ? "#{@task.title} has been completed for #{@task.pet.name}." : "")

        respond_to do |format|
            format.html { redirect_to request.referer, notice: "completed the task!" }
            format.turbo_stream
         end
    end
  end

  private

    def task_params
      params.require(:task).permit(:description, :due_date, :title, :completed, :completed_by, :recurrence, :pet_id)
    end

  def send_line_notification(user_line_id, text_message)
    begin
      @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: ENV["CHANNEL_ACCESS_TOKEN"],
      )

      response = @client.push_message(push_message_request: Line::Bot::V2::MessagingApi::PushMessageRequest.new(
                                        to: user_line_id,
                                        messages: [
                                          Line::Bot::V2::MessagingApi::TextMessage.new(text: text_message),
                                        ],
                                      ))
      Rails.logger.info "LINE Notification Sent: #{response.body}"
    rescue => e
      Rails.logger.error "Error sending LINE notification to #{user_line_id}: #{e.message}"
    end

end
