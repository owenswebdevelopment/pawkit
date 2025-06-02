class MedicalRecordsController < ApplicationController
  # Display a pet's medical records
  def show
    @pet = Pet.find(params[:pet_id])
    @medical_record = @pet.medical_records
  end

  def new
    @pet = Pet.find(params[:pet_id])
    @medical_record = MedicalRecord.new
  end

  def create
    @pet = Pet.find(params[:pet_id])
    @medical_record = MedicalRecord.create(medical_record_params)
    @medical_record.pet = @pet

    if @medical_record.save
      redirect_to pet_medical_record_path(@pet), notice: 'Medical record added!'
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
