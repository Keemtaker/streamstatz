Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/spotify/callback', to: 'users#spotify'
  get '/auth/spotify', to: 'users#spotify'

  get 'top_tracks', to: "users#top_tracks"
  get 'top_artists', to: "users#top_artists"
  get 'recently_played', to: "users#recently_played"

end
