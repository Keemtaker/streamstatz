Rails.application.routes.draw do
  devise_for :users

  scope '(:locale)', locale: /en|fr|es/ do
    root to: 'pages#home'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get '/auth/spotify/callback', to: 'users#spotify'
    get '/auth/spotify', to: 'users#spotify'

    get 'spotify_top_tracks', to: "spotify_users#spotify_top_tracks"
    get 'spotify_top_artists', to: "spotify_users#spotify_top_artists"
    get 'spotify_recently_played', to: "spotify_users#spotify_recently_played"
    get 'spotify_user_genres', to: "spotify_users#spotify_user_genres"
    get 'create_tracks_pdf', to: "spotify_users#create_tracks_pdf"
    get 'create_artists_pdf', to: "spotify_users#create_artists_pdf"

    post 'spotify_create_playlist', to: "spotify_users#spotify_create_playlist"

    match "/404", to: "errors#not_found", via: :all
    match "/422", to: "errors#unacceptable", via: :all
    match "/500", to: "errors#internal_server_error", via: :all
  end
end
