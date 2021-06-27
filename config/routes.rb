Rails.application.routes.draw do
  resources :badges, only: %i[new create] do
    collection do
      get :success
    end
  end

  get '/badges/submit', to: 'badges#new', as: :submit_badges
  get '/badges', to: 'badges#new' # Note: handle refresh after validation failure

  root to: "badges#new"
end
