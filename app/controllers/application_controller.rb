class ApplicationController < ActionController::Base
  before_action :verify_user, if: -> { defined?(Cucumber::Glue) || Rails.env.production? }

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  def verify_user
    # If route is not the sign in page, check if user is signed in
    return if request.path == '/users/sign_in'

    authenticate_user!
    return if current_user.is_active

    sign_out current_user
    redirect_to new_user_session_path, alert: 'Your account is not currently active.'
  end
end
