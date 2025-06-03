class AddGoogleFieldsToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :place_id, :string
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
    add_column :locations, :business_status, :string
    add_column :locations, :rating, :float
    add_column :locations, :user_ratings_total, :integer
    add_column :locations, :first_review, :text
  end
end
