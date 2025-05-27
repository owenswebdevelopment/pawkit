class FamiliesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :join]

  def index
    @families = Family.all
  end

  def join_family_action
    @family = Family.find(params[:id])
    current_user.update(family: @family)
    redirect_to family_path(@family), notice: "You have joined the family!"
  end

  def show
    @family = Family.find(params[:id])
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(strong_params)
    @family.user = current_user
    if @family.save
      redirect_to family_path(@family), notice: "Successfully created family"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def strong_params
    params.require(:family).permit(:name)
  end
end
