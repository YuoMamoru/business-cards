Rails.application.routes.draw do
  resources :cards, except: [ :new ]
  resources :companies do
    resources :cards, only: [ :new ]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
