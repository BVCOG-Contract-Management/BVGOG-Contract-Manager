class ApplicationController < ActionController::Base

    # unless Rails.env.test?
    #     before_action :authenticate_user!
    # end
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_global_config

    protected



    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end
    # Fetch the last bvcog_config from the database
    # and set this as the global config, so that other
    # controllers can access it.
    def set_global_config
        @bvcog_config = BvcogConfig.last
    end

end
