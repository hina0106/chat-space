Rails.application.routes.draw do
  root "messages#index"
  devise_for :users
  resources :users, only: [:edit, :update]
end
