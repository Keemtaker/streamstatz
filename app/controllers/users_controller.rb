class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :spotify]

  def spotify
    auth_details = RSpotify::User.new(request.env['omniauth.auth'])
    user = User.find_or_initialize_by(spotify_id: auth_details.id)
    user.email = auth_details.email
    user.password = Devise.friendly_token[0, 20]
    user.auth_provider = 'spotify'
    user.spotify_id = auth_details.id
    user.spotify_url = auth_details.external_urls.spotify
    user.spotify_display_name = auth_details.display_name
    user.spotify_access_token = auth_details.credentials.token
    user.spotify_refresh_token = auth_details.credentials.refresh_token
    user.spotify_token_expiry_date = auth_details.credentials.expires_at
    user.save!
    if user.save
      sign_in user
      redirect_to spotify_top_tracks_path
    else
      redirect_to root_path
    end
  end


end



