Rails.application.routes.draw do
  # Map root path to pages/home
  root :to => "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

<<<<<<< HEAD
  devise_scope :user do
    get "users/sign_out", to: "devise/sessions#destroy"
  end
  # Example of regular route:
=======
>>>>>>> parent of 8fdf88e (added devise and user login form)
  # Defines the root path route ("/")
  # root "articles#index"
end
