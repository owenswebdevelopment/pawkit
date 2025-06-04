class ChangeCurrentFamilyToBigint < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :current_family, :current_family_id
    change_column :users, :current_family_id, 'bigint USING current_family_id::bigint'
    add_index :users, :current_family_id
  end
end
