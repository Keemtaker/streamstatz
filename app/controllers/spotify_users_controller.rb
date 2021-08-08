class SpotifyUsersController < ApplicationController

  def spotify_top_tracks
    initialize_spotify_user
    @top_tracks_short_term = initialize_spotify_user.top_tracks(time_range: 'short_term', limit: 50)
    @top_tracks_medium_term = initialize_spotify_user.top_tracks(time_range: 'medium_term', limit: 50)
    @top_tracks_long_term = initialize_spotify_user.top_tracks(time_range: 'long_term', limit: 50)
    @number_count = 0
  end

  def spotify_top_artists
    initialize_spotify_user
    @top_artists_short_term = initialize_spotify_user.top_artists(time_range: 'short_term', limit: 50)
    @top_artists_medium_term = initialize_spotify_user.top_artists(time_range: 'medium_term', limit: 50)
    @top_artists_long_term = initialize_spotify_user.top_artists(time_range: 'long_term', limit: 50)
    @number_count = 0
  end

  def spotify_recently_played
    initialize_spotify_user
    @recently_played = initialize_spotify_user.recently_played(limit: 50)
    @number_count = 0
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
