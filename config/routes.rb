Rails.application.routes.draw do
get 'city/show'

  get '/search' => 'city#search'
  get 'city/search'

  get 'home/index'

  resources :city
  resources :home

  root 'home#index'
end
