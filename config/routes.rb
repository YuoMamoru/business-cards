Rails.application.routes.draw do
  root to: "root#index"

  resources :cards
  resources :companies, only: [:index, :show, :create, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
