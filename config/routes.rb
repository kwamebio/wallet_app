Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resource :sessions, only: [:create]
    resource :users, only: [:create, :update]
    resource :wallet, only: [:show] do
      post :credit
      post :send_pin, path: '/credit/send_pin'
      post :send_otp, path: '/credit/send_otp'
      post :transfer
    end
    resource :debit_cards, only: [:create, :destroy] do
      post :send_pin
      post :send_otp
    end
    resources :banks, only: [:index]
    resource :bank_account, only: [] do
      post :verify
    end
    resource :callback, only: [] do
      post :paystack
    end
  end
end
