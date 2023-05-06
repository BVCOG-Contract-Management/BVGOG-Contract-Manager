class ApplicationController < ActionController::Base

    unless Rails.env.development? || Rails.env.test?
        before_action :verify_user
    end
    
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected



    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end

    def verify_user
        # If route is not the sign in page, check if user is signed in
        unless ['/users/sign_in', '/users/sign_out', '/users/password/new', '/users/password', '/users/password/edit', '/users/confirmation', '/users/invitation/accept', '/users/invitation', '/users/invitation/new'].include? request.path
            unless current_user.present?
                redirect_to new_user_session_path, alert: "You must be signed in to access this page."
            end
            authenticate_user!
            unless current_user.is_active
                sign_out current_user
                redirect_to new_user_session_path, alert: "Your account is not currently active."
            end
        end
    end

end
