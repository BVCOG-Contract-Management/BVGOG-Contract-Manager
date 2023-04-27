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
    @bvcog_config.update(bvcog_config_params)
    redirect_to admin_path
  end
end
