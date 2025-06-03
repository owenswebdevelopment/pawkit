class LocationsController < ApplicationController
def index

end

def create
location = Location.find_or_initialize_by(place_id: params[:location][:place_id])
location.assign_attributes(location_params)
location.category ||= "Unknown"
location.address ||= "Unknown address"
location.phone ||= "Unknown"
location.email ||= "Unknown"

if location.save
  render json: { status: "ok" }, status: :created
else
  render json: { status: "error", errors: location.errors.full_messages }, status: :unprocessable_entity
end
end

def location_params
  params.require(:location).permit(
      :place_id,
      :name,
      :latitude,
      :longitude,
      :business_status,
      :rating,
      :user_ratings_total,
      :first_review,
      :category,
      :address,
      :phone,
      :email
    )
end

def favorites
  # @locations = current_user.favorite_locations
  @locations = Location.all
  @location = Location.order(created_at: :desc)
end
end
