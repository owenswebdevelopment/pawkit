class MemoriesController < ApplicationController
  def index
    @family = Family.find(params[:family_id])
    @memory = Memory.new
    @memories = @family.memories
    @memories = @family.memories.includes(:user).order(created_at: :asc)
    #@memory = current_user.family
    #@memories = current_user.memories
  end

  def create
    @family = Family.find(params[:family_id])
    @memory = Memory.new(message_params)
    @memory.family = @family
    @memory.user = current_user
    if @memory.save!
      send_line_notification("C493c98e6e0b758410091ac87570ec99d", "#{@memory.user.first_name} has posted on memories.")
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:memories, partial: "memories/memory",
            target: "memories",
            locals: { memory: @memory })
        end
        format.html { redirect_to family_memories_path(@family) }
      end
    else
      render "", status: :unprocessable_entity
    end
  end

private

def message_params
  params.require(:memory).permit(:text, media: [])
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
end
