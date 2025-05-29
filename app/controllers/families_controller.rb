class FamiliesController < ApplicationController
 

  def index
    @families = current_user.families
  end

  def join_family_action
    family_id = params[:user_family][:family_id]
    @family = Family.find(family_id)
    current_user.families.create(family: @family) unless current_user.families.include?(@family)
    redirect_to family_path(@family), notice: "You joined the family!"
  end

  def show
    @family = Family.find(params[:id])
    @pets = @family.pets
    @tasks = @family.pets.map { |pet| pet.tasks.where(completed: false) }.flatten
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(strong_params)

    if @family.save
      @family.users << current_user unless @family.users.include?(current_user)
      redirect_to family_path(@family), notice: "Successfully created family"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def strong_params
    params.require(:family).permit(:name, :photo)
    # @families = current_user.families
  end
end
