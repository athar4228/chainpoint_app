Rails.application.routes.draw do
  resources :badges, only: %i[new create]

  get '/badges/submit', to: 'badges#new'

  root to: "badges#new"
end
