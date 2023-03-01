class ApplicationController < ActionController::Base
    before_action :set_global_config
    # Fetch the last bvcog_config from the database
    # and set this as the global config, so that other
    # controllers can access it.
    def set_global_config
        @bvcog_config = BvcogConfig.last
    end

end
