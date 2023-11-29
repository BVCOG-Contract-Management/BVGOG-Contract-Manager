# frozen_string_literal: true

require 'factory_bot_rails'

Given('bvcog_config is set up') do
    # BVCOG Config
    # Create the directories if they don't exist
    Dir.mkdir(Rails.root.join('public/contracts')) unless Dir.exist?(Rails.root.join('public/contracts'))
    Dir.mkdir(Rails.root.join('public/reports')) unless Dir.exist?(Rails.root.join('public/reports'))

    # Create the config
    BvcogConfig.create(
        id: 1,
        contracts_path: Rails.root.join('public/contracts'),
        reports_path: Rails.root.join('public/reports')
    )
end

Given('{int} example users exist') do |num_users|
    # Create users
    (1..num_users).each do |i|
        FactoryBot.create(:user,
                          id: i,
                          program: Program.all.sample,
                          first_name: 'User',
                          last_name: i.to_s,
                          entities: Entity.all.sample(rand(1..3)))
    end
end

Given('{int} example programs exist') do |num_programs|
    # Create programs
    (1..num_programs).each do |i|
        FactoryBot.create(
            :program,
            id: i,
            name: "Program #{i}"
        )
    end
end

Given('{int} example entities exist') do |num_entities|
    # Create programs
    (1..num_entities).each do |i|
        FactoryBot.create(
            :entity,
            id: i,
            name: "Entity #{i}"
        )
    end
end

Given('{int} example vendors exist') do |num_vendors|
    # Create programs
    (1..num_vendors).each do |i|
        FactoryBot.create(
            :vendor,
            id: i,
            name: "Vendor #{i}"
        )
    end
end

Given('{int} example contracts exist') do |num_contracts|
    # Create multiple contracts
    statuses = ContractStatus.list.reject { |status| status == :created }
    (1..num_contracts).each do |i|
        d = Time.zone.today + 1.day * i
        FactoryBot.create(
            :contract,
            id: i,
            title: "Contract #{i}",
            entity: Entity.all.sample,
            program: Program.all.sample,
            point_of_contact: User.all.sample,
            vendor: Vendor.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            max_extension_count: i,
            extension_duration: i,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: statuses[i % statuses.length]
        )
    end
end

Given('{int} example contract documents exist') do |num_contract_docs|
    # Create multiple contracts
    (1..num_contract_docs).each do |i|
        FactoryBot.create(
            :contract_document,
            id: i,
            contract: Contract.all.sample
        )
    end
end

Given('{int} example reports exist') do |num_reports|
    (1..num_reports).each do |_i|
        step 'I am on the new report page'
        step 'I follow "Users Report"'
        step 'I fill in "report[title]" with "Example User Report"'
        step 'I press "Create Report"'
    end
end

Given(/^db is set up$/) do
    step '5 example programs exist'
    step '5 example entities exist'
    step '5 example users exist'
    step '5 example vendors exist'
    step '10 example contracts exist'
    step '10 example contract documents exist'

    # Create vendor reviews manually since they have a (user, vendor) unique index
    used_user_vendor_combos = []
    (1..10).each do |i|
        user = User.all.sample
        vendor = Vendor.all.sample
        redo if used_user_vendor_combos.include?([user.id, vendor.id])
        FactoryBot.create(
            :vendor_review,
            id: i,
            user:,
            vendor:
        )
        used_user_vendor_combos << [user.id, vendor.id]
    end
end
