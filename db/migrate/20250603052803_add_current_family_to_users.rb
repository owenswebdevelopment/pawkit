class AddCurrentFamilyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_family, :string
  end
end
