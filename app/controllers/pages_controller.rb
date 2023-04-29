class PagesController < ApplicationController
  def home
    add_breadcrumb "Home", root_path
    if current_user.level == UserLevel::THREE
      # Get last 10 contracts associated with entities user is a member of
      @contracts = Contract.where(entity_id: current_user.entity_ids).order(created_at: :desc).limit(10)
    else
      # Get all contracts with status in review
      @contracts = Contract.where(contract_status: ContractStatus::IN_PROGRESS).order(created_at: :desc)
    end
  end

  def admin
    add_breadcrumb "Administration", admin_path
    @bvcog_config = BvcogConfig.last
  end

  # PUT /admin
  def update_admin
    @bvcog_config = BvcogConfig.last
    respond_to do |format|
      if bvcog_config_params[:contracts_path].present?
        # Check that path is valid, exists, is a directory, and is writable
        if File.directory?(bvcog_config_params[:contracts_path]) && File.writable?(bvcog_config_params[:contracts_path])
          @bvcog_config.contracts_path = bvcog_config_params[:contracts_path]
        else
          @bvcog_config.errors.add(:contracts_path, "is invalid.")
        end
      end
      if bvcog_config_params[:reports_path].present?
        # Check that path is valid, exists, is a directory, and is writable
        if File.directory?(bvcog_config_params[:reports_path]) && File.writable?(bvcog_config_params[:reports_path])
          @bvcog_config.reports_path = bvcog_config_params[:reports_path]
        else
          @bvcog_config.errors.add(:reports_path, "is invalid.")
        end
      end
      if @bvcog_config.errors.any?
        raise StandardError
      end
      if @bvcog_config.save
        format.html { redirect_to admin_path, notice: "Configuration was successfully updated." }
        format.json { render :show, status: :ok, location: @bvcog_config }
      else
        format.html { render 'pages/admin', alert: "Could not save configuration. Please check your settings and try again." }
        format.json { render json: @bvcog_config.errors, status: :unprocessable_entity }
      end
    rescue StandardError => e
      print @bvcog_config.errors.full_messages
      format.html { render 'pages/admin', alert: e.message }
      format.json { render json: @bvcog_config.errors, status: :unprocessable_entity }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def bvcog_config_params
    allowed = %i[
      contracts_path
      reports_path
    ]
    params.require(:bvcog_config).permit(allowed)
  end
end
