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

  def spotify_user_genres
   spotify_top_artists
  end

  def spotify_create_playlist
    initialize_spotify_user
    if params[:time_period] == "short_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'short_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("Monthly Top Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      flash[:notice] = "Nice! Your amazing playlist is on spotify 🎉"
      redirect_to action: "spotify_top_tracks" if response.first.name.present?
    elsif params[:time_period] == "medium_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'medium_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("6 Months Tops Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      flash[:notice] = "Nice! Your amazing playlist is on spotify 🎉"
      redirect_to action: "spotify_top_tracks" if response.first.name.present?
    elsif params[:time_period] == "long_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'long_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("All Time Tops Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      flash[:notice] = "Nice! Your amazing playlist is on spotify 🎉"
      redirect_to action: "spotify_top_tracks" if response.first.name.present?
    end
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
