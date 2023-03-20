Rails.application.routes.draw do
  resources :vendors, param: :name # add this line to use name as a parameter for the show action
  root :to => "pages#home"
end
