class RenameUserTokenToSpotify < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :access_token, :spotify_access_token
    rename_column :users, :refresh_token, :spotify_refresh_token
  end
end
