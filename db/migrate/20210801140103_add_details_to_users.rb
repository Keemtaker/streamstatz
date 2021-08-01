class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :auth_provider, :string
    add_column :users, :spotify_id, :string
    add_column :users, :spotify_url, :string
    add_column :users, :spotify_display_name, :string
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
  end
end
