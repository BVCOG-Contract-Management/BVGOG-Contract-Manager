Rails.application.routes.draw do

  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

  resources :users
  resources :contracts

  # Contract Documents
  # GET
  get "/contract_documents/:id", to: "contract_documents#download", as: "download_contract_document"

  # Map root path to pages/home
  root :to => "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Example of regular route:
  # Defines the root path route ("/")
  # root "articles#index"
end
