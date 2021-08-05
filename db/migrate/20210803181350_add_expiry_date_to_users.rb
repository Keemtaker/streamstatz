class AddExpiryDateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spotify_token_expiry_date, :string
  end
end
