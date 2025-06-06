class TasksController < ApplicationController
  def index
    @family = Family.find(params[:family_id])
    @tasks = @family.tasks.order(:completed) # Ordering tasks by completion status
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      redirect_to request.referer&.split("?")&.first + "?tab=#{@task.recurrence}", notice: 'Saved Successfully'
    else
      @family = Family.find(params[:family_id])
      render "families/show", status: :unprocessable_entity, notice: 'Save unsuccessful'
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.completed_by = current_user
    @task.update(task_params)
    @task.task_memory

    send_line_notification("C493c98e6e0b758410091ac87570ec99d", @task.completed? ? "#{@task.title} has been completed for #{@task.pet.name}." : "")

    respond_to do |format|
      format.html { redirect_to request.referer, notice: "Task completed!" }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "task_#{@task.id}",
          partial: 'tasks/task', locals: { task: @task }
        )
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
        channel_access_token: ENV["CHANNEL_ACCESS_TOKEN"]
      )

      response = @client.push_message(push_message_request: Line::Bot::V2::MessagingApi::PushMessageRequest.new(
                                        to: user_line_id,
                                        messages: [
                                          Line::Bot::V2::MessagingApi::TextMessage.new(text: text_message),
                                        ]
                                      ))
      Rails.logger.info "LINE Notification Sent: #{response.body}"
    rescue => e
      Rails.logger.error "Error sending LINE notification to #{user_line_id}: #{e.message}"
    end
  end
end
