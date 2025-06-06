class MedicalRecordsController < ApplicationController
  # Display a pet's medical records
  def show
    @pet = Pet.find(params[:pet_id])
    @medical_record = MedicalRecord.new
  end

  def new
    @pet = Pet.find(params[:pet_id])
    @medical_record = MedicalRecord.new
  end

  def create
    @pet = Pet.find(params[:pet_id])
    @medical_record = MedicalRecord.create(medical_record_params)
    @medical_record.pet = @pet
    @current_user = current_user

    if @medical_record.save
      send_line_notification("C493c98e6e0b758410091ac87570ec99d", "New medical record was added for #{@pet.name}.")

      @medical_record.medical_memory(current_user)
      redirect_to pet_medical_record_path(@pet, @medical_record), notice: 'Medical record added!'
    else
      render turbo_stream: turbo_stream.replace(
        "medical_record_form",
        partial: 'medical_records/new', locals: {
          pet: @pet,
          medical_record: @medical_record
        }
      )
    end
  end

  private

  def medical_record_params
    params.require(:medical_record).permit(:diagnosis, :notes, :visit_date, :treatment, :vaccination_status, :insurance_status, :location_id)
  end
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
