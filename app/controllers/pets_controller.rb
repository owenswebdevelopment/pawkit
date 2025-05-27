class PetsController < ApplicationController
  def new
    @family = Family.find(params[:family_id])
    @pet = Pet.new
  end

  def create
    @family = Family.find(params[:family_id])
    @pet = Pet.new

    if @pet.save
      redirect_to family_pet_path(@family, @pet), notice: 'Pet was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :age, :gender, :color, :birthdate, :species)
  end
end
