# frozen_string_literal: true

class InvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters

    def new
        if current_user.level != UserLevel::ONE
            redirect_to users_url, alert: 'You are not authorized to invite users.'
            return
        end
        add_breadcrumb 'Users', users_path
        add_breadcrumb 'Invite User', new_user_path

        super
    end

    def create
        add_breadcrumb 'Users', users_path
        add_breadcrumb 'Invite User', new_user_path

        @user = User.new(user_params)
        @user.password = SecureRandom.hex(8)

        respond_to do |format|
            OSO.authorize(current_user, 'write', @user)
            if @user.save
                # Send invitation email
                @user.invite!
                format.html { redirect_to user_url(@user), notice: 'User was successfully invited.' }
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        rescue Oso::Error => e
            format.html { redirect_to users_url, alert: 'You are not authorized to invite users.' }
            format.json { render json: { error: e.message }, status: :unprocessable_entity }
        end
    end

    protected

    # Permit the new params here.
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:invite, keys: %i[first_name last_name])
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :level, :is_program_manager, :program_id,
                                     :redirect_user_id, :is_active, entity_ids: [])
    end
end
