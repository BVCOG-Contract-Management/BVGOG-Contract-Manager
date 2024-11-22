# frozen_string_literal: true

# Controller for pages
class PagesController < ApplicationController
    def home
        add_breadcrumb 'Home', root_path
        # Fetch contracts using the new method for the home page
        @contracts = home_contracts
        @amendments_and_renewals = home_amendments_and_renewals
    end

    # Method to retrieve contracts for the home page based on the user's level and entities
    def home_contracts
        contracts = Contract.where(entity_id: current_user.entity_ids, current_type: 'contract')

        if current_user.level == UserLevel::THREE
            # Get contracts in progress for level 3 users
            contracts.where(contract_status: ContractStatus::IN_PROGRESS).order(created_at: :desc)
        else
            # Get contracts in review for all other users
            contracts.where(contract_status: ContractStatus::IN_REVIEW).order(created_at: :desc)
        end
    end

    # Method to retrieve amendments and renewals for the home page based on the user's level and entities
    def home_amendments_and_renewals
        amendments_and_renewals = Contract.where(entity_id: current_user.entity_ids)
                                          .where(current_type: %w[amend renew])

        if current_user.level == UserLevel::THREE
            amendments_and_renewals.where(contract_status: ContractStatus::IN_PROGRESS).order(created_at: :desc)
        else
            amendments_and_renewals.where(contract_status: ContractStatus::IN_REVIEW).order(created_at: :desc)
        end
    end

    def admin
        # :nocov:
        if current_user.level != UserLevel::ONE
            Rails.logger.debug 'We not an Admin\n'
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
        end
        Rails.logger.debug 'We an Admin\n'
        add_breadcrumb 'Administration', admin_path
        @bvcog_config = BvcogConfig.last
        # Map the :users field to IDs of users
        @bvcog_config.user_ids = @bvcog_config.users.map(&:id)
        # :nocov:
        filter_users
    end

    # PUT /admin
    def update_admin
        # :nocov:
        if current_user.level != UserLevel::ONE
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
        end

        @bvcog_config = BvcogConfig.last
        respond_to do |format|
            # Change contracts path
            if bvcog_config_params[:contracts_path].present?
                # Check that path is valid, exists, is a directory, and is writable
                if File.directory?(bvcog_config_params[:contracts_path]) && File.writable?(bvcog_config_params[:contracts_path])
                    @bvcog_config.contracts_path = bvcog_config_params[:contracts_path]
                    # Update all contract documents with new path
                    ContractDocument.all.find_each do |contract_document|
                        full_path = File.join(@bvcog_config.contracts_path, contract_document.file_name).to_s
                        contract_document.update(full_path:)
                    end
                else
                    @bvcog_config.errors.add(:contracts_path, 'is invalid.')
                end
            end

            # Change reports path
            if bvcog_config_params[:reports_path].present?
                # Check that path is valid, exists, is a directory, and is writable
                if File.directory?(bvcog_config_params[:reports_path]) && File.writable?(bvcog_config_params[:reports_path])
                    @bvcog_config.reports_path = bvcog_config_params[:reports_path]
                    # Update all report documents with new path
                    Report.all.find_each do |report|
                        full_path = File.join(@bvcog_config.reports_path, report.file_name).to_s
                        report.update(full_path:)
                    end
                else
                    @bvcog_config.errors.add(:reports_path, 'is invalid.')
                end
            end

            # Create new programs
            if bvcog_config_params[:new_programs].present? && bvcog_config_params[:new_programs].length.positive?
                # Split on commas and remove empty strings
                new_programs = bvcog_config_params[:new_programs].split(',').reject(&:empty?)
                # Create new programs
                new_programs.each do |program|
                    # Check if program already exists
                    program = program.strip.titlecase
                    if Program.where(name: program).count.zero?
                        Program.create(name: program)
                    else
                        @bvcog_config.errors.add('Attempted to create existing program,',
                                                 "programs include: #{Program.all.map(&:name).join(', ')}")
                    end
                end
            end

            # Create new entities
            if bvcog_config_params[:new_entities].present? && bvcog_config_params[:new_entities].length.positive?
                # Split on commas and remove empty strings
                new_entities = bvcog_config_params[:new_entities].split(',').reject(&:empty?)
                # Create new entities
                new_entities.each do |entity|
                    # Check if entity already exists
                    entity = entity.strip.titlecase
                    if Entity.where(name: entity).count.zero?
                        Entity.create(name: entity)
                    else
                        @bvcog_config.errors.add('Attempted to create existing entity,',
                                                 "entities include: #{Entity.all.map(&:name).join(', ')}")
                    end
                end
            end

            # Delete programs
            if bvcog_config_params[:delete_programs].present? && bvcog_config_params[:delete_programs].any?
                # Delete programs
                bvcog_config_params[:delete_programs].each do |program|
                    # Check no users are associated with program
                    if User.where(program_id: program).count.positive?
                        @bvcog_config.errors.add('Attempted to delete program with associated users',
                                                 "program: #{Program.find(program).name}")
                    # Check no contracts are associated with program
                    elsif Contract.where(program_id: program).count.positive?
                        @bvcog_config.errors.add('Attempted to delete program with associated contracts',
                                                 "program: #{Program.find(program).name}")
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
                    if Entity.find(entity).users.count.positive?
                        @bvcog_config.errors.add('Attempted to delete entity with associated users',
                                                 "entity: #{Entity.find(entity).name}")
                    # Check no contracts are associated with entity
                    elsif Contract.where(entity_id: entity).count.positive?
                        @bvcog_config.errors.add('Attempted to delete entity with associated contracts',
                                                 "entity: #{Entity.find(entity).name}")
                    else
                        Entity.find(entity).destroy
                    end
                end
            end

            # Automated Expiration Report Users
            # Always clear, if param not present, no users will be added
            @bvcog_config.users.clear
            if bvcog_config_params[:user_ids].present? && bvcog_config_params[:user_ids].any?
                bvcog_config_params[:user_ids].each do |id|
                    @bvcog_config.users << User.find(id)
                end
            end

            raise StandardError if @bvcog_config.errors.any?

            if @bvcog_config.save
                format.html { redirect_to admin_path, notice: 'Configuration was successfully updated.' }
                format.json { render :show, status: :ok, location: @bvcog_config }
            else
                filter_users
                format.html do
                    render 'pages/admin',
                           alert: 'Could not save configuration. Please check your settings and try again.'
                end
                format.json { render json: @bvcog_config.errors, status: :unprocessable_entity }
            end
        rescue StandardError => e
            filter_users
            format.html { render 'pages/admin', alert: e.message }
            format.json { render json: @bvcog_config.errors, status: :unprocessable_entity }
        end
        # :nocov:
    end

    #get /admin/delete_program
    def delete_program
      program = params[:program_id]
      if not program.present? 
        redirect_to admin_path, alert: 'program_id not found in params.'
        return;
      end
      @bvcog_config = nil
      respond_to do |format|
        # Check no users are associated with program
        if User.where(program_id: program).count.positive?
          @bvcog_config ||= BvcogConfig.last
          @bvcog_config.errors.add('Attempted to delete program with associated users.',
                                   "program: #{Program.find(program).name}")
          # Check no contracts are associated with program
        elsif Contract.where(program_id: program).count.positive?
          @bvcog_config ||= BvcogConfig.last
          @bvcog_config.errors.add('Attempted to delete program with associated contracts.',
                                   "program: #{Program.find(program).name}")
        else
          Program.find(program).destroy
        end
        raise StandardError if (not @bvcog_config.nil? and @bvcog_config.errors.any?)
        format.html { redirect_to admin_path, notice: 'Configuration was successfully updated.' }
        format.json { render :show, status: :ok}
      rescue StandardError => e
        @bvcog_config ||= BvcogConfig.last
        filter_users
        format.html { render 'pages/admin', alert: e.message }
        format.json { render json: @bvcog_config.errors, status: :unprocessable_entity }
      end
    end

    # /admin/delete_entity
    def delete_entity
      entity = params[:entity_id]
      if not entity.present? 
        redirect_to admin_path, alert: 'entity_id not found in params.'
        return;
      end
      @bvcog_config = nil
      respond_to do |format|
        # Check no users have this entity in their list of entities
        if Entity.find(entity).users.count.positive?
          @bvcog_config ||= BvcogConfig.last
          @bvcog_config.errors.add('Attempted to delete entity with associated users.',
                                   "entity: #{Entity.find(entity).name}")
          # Check no contracts are associated with entity
        elsif Contract.where(entity_id: entity).count.positive?
          @bvcog_config ||= BvcogConfig.last
          @bvcog_config.errors.add('Attempted to delete entity with associated contracts.',
                                   "entity: #{Entity.find(entity).name}")
        else
          Entity.find(entity).destroy
        end
        raise StandardError if (not @bvcog_config.nil? and @bvcog_config.errors.any?)
        format.html { redirect_to admin_path, notice: 'Configuration was successfully updated.' }
        format.json { render :show, status: :ok}
      rescue StandardError => e
        @bvcog_config ||= BvcogConfig.last
        filter_users
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

    def filter_users
        @flter_entity_id = params[:flter_entity_id]
        @flter_program_id = params[:flter_program_id]
        if @flter_entity_id.present?
          @flter_entity_id = @flter_entity_id.to_i
          entity_a = Entity.where(id: @flter_entity_id)
          if entity_a.any?
            @selected_users = entity_a[0].users
            if @flter_program_id.present?
              @flter_program_id = @flter_program_id.to_i
              @selected_users = @selected_users.where(program_id: @flter_program_id)
            end
          else
            @selected_users = []
          end
        else
          if @flter_program_id.present?
            @flter_program_id = @flter_program_id.to_i
            @selected_users = User.where(program_id: @flter_program_id)
          else
            @selected_users = User.all
          end
        end
    end
end
