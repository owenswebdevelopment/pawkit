class AddInviteTokenToFamilies < ActiveRecord::Migration[7.1]
  def change
    add_column :families, :invite_token, :string
  end
end
