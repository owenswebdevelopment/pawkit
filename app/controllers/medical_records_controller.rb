class MedicalRecordsController < ApplicationController
  # Display a pet's medical records
  def show
    @pet = Pet.find(params[:pet_id])
    @medical_record = @pet.medical_records.find(params[:id])
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
      redirect_to pet_path(@pet), notice: 'Medical record added!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medical_record_params
    params.require(:medical_record).permit(:diagnosis, :notes, :visit_date, :treatment, :vaccination_status, :insurance_status, :location_id)
  end
end
