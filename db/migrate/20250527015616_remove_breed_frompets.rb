class RemoveBreedFrompets < ActiveRecord::Migration[7.1]
  def change
    remove_column :pets, :breed, :string
  end
end
