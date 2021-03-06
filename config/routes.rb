Rails.application.routes.draw do
  root to: 'flights#index'

  resources :flights, only: %i[index show] do
    resources :bookings, only: %i[new create show], shallow: true
  end

  get '/search/' => 'flights#search', :as => :flights_search
  get '/update_airports' => 'flights#update_airports', :as => :update_airports
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
