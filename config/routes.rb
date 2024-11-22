# frozen_string_literal: true

Rails.application.routes.draw do
    devise_for :users, controllers: { invitations: 'invitations', registrations: 'devise/registrations' }
    authenticated :user do
        root to: 'pages#home'
    end

    unauthenticated do
        root to: redirect('/users/sign_in'), as: :unauthenticated_root
    end

    # GET /admin
    get '/admin', to: 'pages#admin', as: 'admin'
    put '/admin', to: 'pages#update_admin', as: 'update_admin'
    get '/admin/delete_program', to: 'pages#delete_program', as: 'delete_program'
    get '/admin/delete_entity', to: 'pages#delete_entity', as: 'delete_entity'

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
        post 'rejection', to: 'contracts#log_rejection', as: 'log_rejection'
        post 'log_hard_rejection', to: 'contracts#log_hard_rejection', as: 'log_hard_rejection'
        post 'approve', to: 'contracts#log_approval', as: 'log_approval'
        post 'return', to: 'contracts#log_return', as: 'log_return'
        post 'submit', to: 'contracts#log_submission', as: 'log_submission'
        collection do
            get 'modify'
        end
        member do
            get 'renew', to: 'contracts#edit'
        end
        member do
            get 'amend', to: 'contracts#edit'
        end
    end

    get '/contracts/:id/expiry_reminder', to: 'contracts#expiry_reminder', as: 'expiry_reminder_contract'

    # Contract Void Actions
    get '/contracts/:id/void', to: 'contracts#void', as: 'void_contract'

    # Contract Rejections
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
