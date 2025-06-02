class AddCoordinatesToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :lat, :float
    add_column :locations, :lon, :float
  end
end
