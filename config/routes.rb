Rails.application.routes.draw do

  devise_for :users

  resources :contracts

  # Map root path to pages/home
  root :to => "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    get 'users/sign_out', to: 'devise/sessions#destroy'
  end
  # Example of regular route:
  # Defines the root path route ("/")
  # root "articles#index"
end
