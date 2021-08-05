class SpotifyUsersController < ApplicationController

  def spotify_top_tracks
    initialize_spotify_user
    @top_tracks = initialize_spotify_user.top_tracks(time_range: 'short_term')
  end

  def spotify_top_artists
    initialize_spotify_user
    @top_artists = initialize_spotify_user.top_artists(time_range: 'short_term')
    raise
  end

  def spotify_recently_played
    initialize_spotify_user
    @recently_played = initialize_spotify_user.recently_played
  end

  private

  def initialize_spotify_user
    spotify_user = RSpotify::User.new(
    {
      'credentials' => {
         "token" => current_user.spotify_access_token,
         "refresh_token" => current_user.spotify_refresh_token,
      } ,
      'id' => current_user.spotify_id
    })
  end

end
