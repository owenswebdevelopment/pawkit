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
      redirect_to pet_path(@pet), notice: 'Pet was successfully created!'
    else
      @family = Family.find(params[:family_id])
      render :new, status: :unprocessable_entity
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
end
