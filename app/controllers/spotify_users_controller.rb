class SpotifyUsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create_pdf]

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
    if time_period_params[:time_period] == "short_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'short_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("#{t('pages.home.last_month')} Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      if response.first.name.present?
        flash[:alert] = t('spotify_users.spotify_top_tracks.playlist_alert')
        redirect_to action: "spotify_top_tracks"
        playlist_slack_notification(playlist)
      end
    elsif time_period_params[:time_period] == "medium_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'medium_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("#{t('pages.home.last_6_months')} Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      if response.first.name.present?
        flash[:alert] = t('spotify_users.spotify_top_tracks.playlist_alert')
        redirect_to action: "spotify_top_tracks"
        playlist_slack_notification(playlist)
      end
    elsif time_period_params[:time_period] == "long_term"
      tracks = initialize_spotify_user.top_tracks(time_range: 'long_term', limit: 50)
      playlist = initialize_spotify_user.create_playlist!("#{t('pages.home.all_time')} Tracks(#{Time.now.strftime('%d-%b-%y')}, StreamStatz)", public: false)
      response = playlist.add_tracks!(tracks)
      if response.first.name.present?
        flash[:alert] = t('spotify_users.spotify_top_tracks.playlist_alert')
        redirect_to action: "spotify_top_tracks"
        playlist_slack_notification(playlist)
      end
    end
  end

  def create_tracks_pdf
    require "RMagick"
    initialize_spotify_user
    if time_period_params[:time_period] == "short_term"
      @tracks = initialize_spotify_user.top_tracks(time_range: 'short_term', limit: 10)
      @time_period = t('pages.home.last_month')
    elsif time_period_params[:time_period] == "medium_term"
      @tracks = initialize_spotify_user.top_tracks(time_range: 'medium_term', limit: 10)
      @time_period = t('pages.home.last_6_months')
    elsif time_period_params[:time_period] == "long_term"
      @tracks = initialize_spotify_user.top_tracks(time_range: 'long_term', limit: 10)
      @time_period = t('pages.home.all_time')
    end
    pdf_to_png('create_tracks')

  end

  def create_artists_pdf
    require "RMagick"
    initialize_spotify_user
    if time_period_params[:time_period] == "short_term"
      @artists = initialize_spotify_user.top_artists(time_range: 'short_term', limit: 10)
      @time_period = t('pages.home.last_month')
    elsif time_period_params[:time_period] == "medium_term"
      @artists = initialize_spotify_user.top_artists(time_range: 'medium_term', limit: 10)
      @time_period = t('pages.home.last_6_months')
    elsif time_period_params[:time_period] == "long_term"
      @artists = initialize_spotify_user.top_artists(time_range: 'long_term', limit: 10)
      @time_period = t('pages.home.all_time')
    end
    pdf_to_png('create_artists')

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

  def pdf_to_png(view_template)
    pdf_name = current_user.spotify_display_name + rand(1..100).to_s
    png_name = "#{Rails.root.join}/tmp/StreamStatz-#{@time_period}-#{pdf_name}.png"

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "StreamStatz",
        page_size: 'A4',
        template: "spotify_users/#{view_template}_pdf.html.erb",
        orientation: "Portrait",
        lowquality: false,
        encoding: 'utf8',
        save_to_file: Rails.root.join('tmp', "#{pdf_name}.pdf")
      end
    end

    pdf = Magick::ImageList.new(Rails.root.join("tmp/#{pdf_name}.pdf")) do
          self.quality = 200
          self.density = 300
          self.colorspace = Magick::RGBColorspace
          self.interlace = Magick::NoInterlace
        end.each_with_index do |img|
          img.resize_to_fit!(1080, 1920)
          img.write(png_name)
    end
    send_file png_name
  end

  def time_period_params
    params.permit(:time_period)
  end

  def playlist_slack_notification(playlist_value)
    SlackNotifier::PLAYLIST_SLACK.ping("🎶🔥 New playlist\nUsername: #{playlist_value.owner.display_name}. See at #{playlist_value.owner.external_urls['spotify']}\nPlaylist_url: #{playlist_value.external_urls['spotify']}")
  end

end
