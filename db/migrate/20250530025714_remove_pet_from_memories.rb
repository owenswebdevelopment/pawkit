class RemovePetFromMemories < ActiveRecord::Migration[7.1]
  def change
    remove_reference :memories, :pet, foreign_key: true
  end
end
