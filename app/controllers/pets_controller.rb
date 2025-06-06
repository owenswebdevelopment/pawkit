class PetsController < ApplicationController
  def new
    @family = Family.find(params[:family_id])
    @pet = Pet.new
  end

  def show
    @pet = Pet.find(params[:id])
    @family = @pet.family
    @task = Task.new
    @medical_record = MedicalRecord.new
  end

  def create
    @pet = Pet.new(pet_params)
    @family = Family.find(params[:family_id])
    @pet.family = @family

    if @pet.save
        send_line_notification("C83272dbd2c1e3a219ff9ba2d248f1135", "#{@pet.name} has been added to the family.")

      redirect_to pet_path(@family, @pet), notice: 'Pet was successfully created!'
    else
      @family = Family.find(params[:family_id])
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    @pet.update(pet_params)
    redirect_to pet_path(@pet)
  end

  def destroy
    @pet = Pet.find(params[:id])
    @family = @pet.family

    if @pet.destroy
      redirect_to family_path(@family), notice: 'Pet was successfully deleted.', status: :see_other
    else
      redirect_to family_path, alert: 'Pet could not be deleted.', status: :see_other
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :age, :gender, :color, :birthdate, :species, :photo)
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
  # def send_line_notification(message)
  #   uri = URI.parse("https://api.line.me/v2/bot/message/push")
  #   request = Net::HTTP::Post.new(uri)
  #   request["Authorization"] = "Bearer #{ENV.fetch('LINE_CHANNEL_ACCESS_TOKEN')}"

  #   request["Content-Type"] = "application/json"
  #   request.body = {
  #     to: ENV["LINE_GROUP_ID"], # Replace with actual group ID
  #     messages: [{ type: "text", text: message }]
  #   }.to_json

  #   response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
  #     http.request(request)
  #   end

  #  puts response.body
  # end
end
