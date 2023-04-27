Rails.application.routes.draw do

  devise_for :users, controllers: { invitations: 'invitations' }
  
  authenticated :user do
    root :to => "pages#home"
  end
  
  unauthenticated do
    root to: redirect('/users/sign_in'), as: :unauthenticated_root
  end

  resources :vendors do
    member do
      get 'review'
    end
    resources :vendor_reviews
  end

  resources :users do
    member do
      get 'redirect'
    end
  end
  resources :reports
  resources :contracts

  # Contract Documents
  # GET
  get "/contract_documents/:id", to: "contract_documents#download", as: "download_contract_document"

  # Download Report
  # GET
  get "/reports/:id/download", to: "reports#download", as: "download_report"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Example of regular route:
  # Defines the root path route ("/")
  # root "articles#index"
end
