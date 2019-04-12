Rails.application.routes.draw do
  root to: "root#index"

  resources :cards
  post "cards/ocr", format: "json", to: "cards#ocr", as: "card_ocr"
  resources :companies, except: [ :destroy ]
  get "api/postcode", format: "json", to: "api#postcode", as: "poostcode"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
