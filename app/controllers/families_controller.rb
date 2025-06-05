class FamiliesController < ApplicationController
  def index
    # @family = Family.find[:user_family][:family_id]
    @families = current_user.families
    @family = Family.all
  end

  # def join_family_action
  #   family_id = params[:user_family][:family_id]
  #   @family = Family.find(family_id)
  #   current_user.families.create(family: @family) unless current_user.families.include?(@family)
  #   redirect_to family_path(@family), notice: "You joined the family!"
  # end

  def join_family_action
    @family = Family.find_by(invite_token: params[:invite_token])
    if @family && !current_user.families.include?(@family)
      current_user.families << @family
      current_user.update(current_family_id: @family.id)
      flash[:notice] = "You've joined the family!"
    else
      flash[:alert] = "Invalid family code or already a member."
    end
    redirect_to families_path
  end

  def show
    @pet = Pet.new
    @family = Family.find(params[:id])
    @pets = @family.pets
    @tasks = @family.tasks
    @task = Task.new
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(strong_params)

    if @family.save
      @family.users << current_user unless @family.users.include?(current_user)
      redirect_to family_path(@family), notice: "Family Created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_current_family
    @current_family = Family.find(params[:id])
    # current_user.update(current_family: @current_family.id.to_s)
    current_user.update(current_family_id: @current_family.id)

    redirect_to family_path(@current_family)
  end

  private

  def strong_params
    params.require(:family).permit(:name, :photo)
    # @families = current_user.families
  end
end
