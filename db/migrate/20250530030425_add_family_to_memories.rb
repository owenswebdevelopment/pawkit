class AddFamilyToMemories < ActiveRecord::Migration[7.1]
  def change
    add_reference :memories, :family, null: false, foreign_key: true
  end
end
