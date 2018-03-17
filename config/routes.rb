Rails.application.routes.draw do
  root to: "root#index"

  resources :cards, except: [ :new ]
  resources :companies, only: [:index, :show, :create, :update] do
    resources :cards, only: [ :new ]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
