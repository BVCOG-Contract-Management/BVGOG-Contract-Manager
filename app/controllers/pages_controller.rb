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
    if current_user.level != UserLevel::ONE
      redirect_to root_path, alert: "You do not have permission to access this page."
      return
    end
    add_breadcrumb "Administration", admin_path
    @bvcog_config = BvcogConfig.last
    # Map the :users field to IDs of users
    @bvcog_config.user_ids = @bvcog_config.users.map { |user| user.id }
  end

  # PUT /admin
  def update_admin
    @bvcog_config = BvcogConfig.last
    respond_to do |format|

      # Change contracts path
      if bvcog_config_params[:contracts_path].present?
        # Check that path is valid, exists, is a directory, and is writable
        if File.directory?(bvcog_config_params[:contracts_path]) && File.writable?(bvcog_config_params[:contracts_path])
          @bvcog_config.contracts_path = bvcog_config_params[:contracts_path]
        else
          @bvcog_config.errors.add(:contracts_path, "is invalid.")
        end
      end

      # Change reports path
      if bvcog_config_params[:reports_path].present?
        # Check that path is valid, exists, is a directory, and is writable
        if File.directory?(bvcog_config_params[:reports_path]) && File.writable?(bvcog_config_params[:reports_path])
          @bvcog_config.reports_path = bvcog_config_params[:reports_path]
        else
          @bvcog_config.errors.add(:reports_path, "is invalid.")
        end
      end

      # Create new programs
      if bvcog_config_params[:new_programs].present? && bvcog_config_params[:new_programs].length > 0
        # Split on commas and remove empty strings
        new_programs = bvcog_config_params[:new_programs].split(",").reject(&:empty?)
        # Create new programs
        new_programs.each do |program|
          # Check if program already exists
          if Program.where(name: program).count == 0
            Program.create(name: program)
          else 
            @bvcog_config.errors.add("Attempted to create existing program,", "programs include: #{Program.all.map(&:name).join(", ")}")
          end
        end
      end

      # Create new entities
      if bvcog_config_params[:new_entities].present? && bvcog_config_params[:new_entities].length > 0
        # Split on commas and remove empty strings
        new_entities = bvcog_config_params[:new_entities].split(",").reject(&:empty?)
        # Create new entities
        new_entities.each do |entity|
          # Check if entity already exists
          if Entity.where(name: entity).count == 0
            Entity.create(name: entity)
          else
            @bvcog_config.errors.add("Attempted to create existing entity,", "entities include: #{Entity.all.map(&:name).join(", ")}")
          end
        end
      end

      # Delete programs
      if bvcog_config_params[:delete_programs].present? && bvcog_config_params[:delete_programs].any?
        # Delete programs
        bvcog_config_params[:delete_programs].each do |program|
          # Check no users are associated with program
          if User.where(program_id: program).count > 0
            @bvcog_config.errors.add("Attempted to delete program with associated users", "program: #{Program.find(program).name}")
          # Check no contracts are associated with program
          elsif Contract.where(program_id: program).count > 0
            @bvcog_config.errors.add("Attempted to delete program with associated contracts", "program: #{Program.find(program).name}")
          else
            Program.find(program).destroy
          end
        end
      end

      # Delete entities
      if bvcog_config_params[:delete_entities].present? && bvcog_config_params[:delete_entities].any?
        # Delete entities
        bvcog_config_params[:delete_entities].each do |entity|
          # Check no users have this entity in their list of entities
          if Entity.find(entity).users.count > 0
            @bvcog_config.errors.add("Attempted to delete entity with associated users", "entity: #{Entity.find(entity).name}")
          # Check no contracts are associated with entity
          elsif Contract.where(entity_id: entity).count > 0
            @bvcog_config.errors.add("Attempted to delete entity with associated contracts", "entity: #{Entity.find(entity).name}")
          else
            Entity.find(entity).destroy
          end
        end
      end

      # Automated Expiration Report Users
      # Alsways clear, if param not present, no users will be added
      @bvcog_config.users.clear
      if bvcog_config_params[:user_ids].present? && bvcog_config_params[:user_ids].any?
        bvcog_config_params[:user_ids].each do |id|
          @bvcog_config.users << User.find(id)
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
      raise e
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
      new_programs
      new_entities
    ]
    params.require(:bvcog_config).permit(allowed, delete_programs: [], delete_entities: [], user_ids: [])
  end
  
end
