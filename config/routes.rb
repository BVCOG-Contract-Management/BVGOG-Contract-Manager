# frozen_string_literal: true

Rails.application.routes.draw do
    devise_for :users, controllers: { invitations: 'invitations' }

    authenticated :user do
        root to: 'pages#home'
    end

    unauthenticated do
        root to: redirect('/users/sign_in'), as: :unauthenticated_root
    end

    # GET /admin
    get '/admin', to: 'pages#admin', as: 'admin'
    put '/admin', to: 'pages#update_admin', as: 'update_admin'

    resources :vendors do
        member do
            get 'review'
        end
        resources :vendor_reviews
    end

    resources :users do
        # PUT /users/1/redirect
        member do
            put 'redirect', to: 'users#redirect', as: 'redirect'
            get 'reinvite', to: 'users#reinvite', as: 'reinvite'
        end
    end
    resources :reports
    resources :contracts do
        member do
            patch :reject_contract
        end
    end

    get '/contracts/:id/expiry_reminder', to: 'contracts#expiry_reminder', as: 'expiry_reminder_contract'
    get '/contracts/:id/reject', to: 'contracts#reject', as: 'reject_contract'

    # Contract Documents
    # GET

    get '/contract_documents/:id', to: 'contract_documents#download', as: 'download_contract_document'

    # Download Report
    # GET
    get '/reports/:id/download', to: 'reports#download', as: 'download_report'

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Example of regular route:
    # Defines the root path route ("/")
    # root "articles#index"
end
