class PetsController < ApplicationController
  def new
    @family = Family.find(params[:family_id])
    @pet = @family.pets.new
  end

  def create
    @family = Family.find(params[:family_id])
    @pet = @family.pets.new(pet_params)

    if @pet.save
      redirect_to family_pet_path(@family, @pet), notice: 'Pet was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def pet_params
    params.require(:pet).permit(:name, :age, :gender, :color, :birth_date)
  end
end
