class ApplicationController < ActionController::Base
<<<<<<< HEAD
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
=======
>>>>>>> parent of 8fdf88e (added devise and user login form)
end
