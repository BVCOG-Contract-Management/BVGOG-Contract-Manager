# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'factory_bot_rails'

# Redirect stdout to a null device
# orig_stdout = $stdout.clone
# $stdout.reopen(File.new('/dev/null', 'w'))

TYPE = %w[
    contract
    amend
    renew
].freeze

if Rails.env.production?
    # ------------ PROD SEEDS ------------

    PROGRAM_NAMES = [
        '9-1-1',
        'AAA',
        'Admin',
        'CIHC',
        'ECD',
        'Energy-CSBG',
        'Fiber',
        'Head Start',
        'HIV',
        'Housing',
        'PSP',
        'PSA',
        'Solid Waste',
        'Transportation',
        'WIC',
        'Workforce'
    ].freeze

    # Create programs
    PROGRAM_NAMES.each do |program_name, i|
        FactoryBot.create(
            :program,
            id: i,
            name: program_name
        )
    end

    ENTITY_NAMES = %w[
        BVCOG
        BVCAP
        Brazos2020
    ].freeze

    # Create entities
    ENTITY_NAMES.each do |entity_name|
        FactoryBot.create(
            :entity,
            name: entity_name
        )
    end

    # Create admin user
    FactoryBot.create(
        :user,
        email: 'admin@bvcogdev.com',
        password: 'password',
        first_name: 'BVCOG',
        last_name: 'Admin',
        level: UserLevel::ONE,
        program: Program.first,
        invitation_accepted_at: Time.zone.now
    )

    # Create gatekeeper user
    FactoryBot.create(
        :user,
        email: 'gatekeeper@bvcogdev.com',
        password: 'password',
        first_name: 'BVCOG',
        last_name: 'Gatekeeper',
        level: UserLevel::TWO,
        program: Program.first,
        invitation_accepted_at: Time.zone.now
    )

    # Create user
    FactoryBot.create(
        :user,
        email: 'user@bvcogdev.com',
        password: 'password',
        first_name: 'BVCOG',
        last_name: 'User',
        level: UserLevel::THREE,
        program: Program.first,
        invitation_accepted_at: Time.zone.now
    )

    # Create multiple contracts
    (1..50).each do |i|
        FactoryBot.create(
            :vendor,
            id: i,
            name: "Vendor #{i}"
        )
        # Create Contracts
        d = Time.zone.today + 1.day * i
        statuses = ContractStatus.list.reject { |status| status == :created }
        FactoryBot.create(
            :contract,
            id: i + 151,
            current_type: TYPE[0],
            title: "Contract #{i}",
            entity: Entity.all.sample,
            program: Program.all.sample,
            point_of_contact: User.all.sample,
            vendor: Vendor.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            extension_duration: i.months,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: statuses.sample
        )

        # Create Amendments/Renewals
        d = Time.zone.today + 1.day * i
        statuses = ContractStatus.list.reject { |status| status == :created }
        contract_type = TYPE.select { |type| %w[amend renew].include?(type) }
        selected_type = contract_type.sample

        FactoryBot.create(
            :contract,
            id: i + 201,
            current_type: selected_type,
            title: "#{selected_type.capitalize} #{i}",
            entity: Entity.all.sample,
            program: Program.all.sample,
            point_of_contact: User.all.sample,
            vendor: Vendor.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            extension_duration: i.months,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: (statuses - ['approved']).sample
        )
    end

    # Create a user to test expiry reminder email
    contact_person = FactoryBot.create(
        :user,
        email: 's794613820@gmail.com',
        password: 'password',
        first_name: 'Test Email',
        last_name: 'Expiry reminder',
        level: UserLevel::THREE,
        program: Program.first,
        invitation_accepted_at: Time.zone.now
    )

    # contact_person = User.find_by(email: 'user@example.com')
    # Create some documents with nearby expiries to test expiring docs mailer
    statuses = ContractStatus.list.reject { |status| status == :created }
    (1..100).each do |i|
        d = Time.zone.today + 1.day * i
        FactoryBot.create(
            :contract,
            id: 50 + i,
            point_of_contact: contact_person,
            title: "Expiry Contract #{i}",
            program: Program.all.sample,
            vendor: Vendor.all.sample,
            entity: Entity.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            extension_duration: i,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: statuses.sample
        )
    end

    # Reset and generate modification logs/decision histories for approved contracts
    Contract.where(contract_status: ContractStatus::APPROVED).find_each do |contract|
        # Generate Modification Logs
        10.times do
            existing_contract_ids = Contract.pluck(:id)
            new_contract_id = (1..100).to_a.find { |id| !existing_contract_ids.include?(id) }

            # Define potential changes
            potential_changes = {
                'contract_id' => [contract.id, new_contract_id],
                'starts_at' => [
                    (contract.starts_at - rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S'),
                    (contract.starts_at + rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S')
                ],
                'ends_at' => [
                    (contract.ends_at - rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S'),
                    (contract.ends_at + rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S')
                ],
                'summary' => ['Previous Summary', "Updated Summary #{Faker::Lorem.paragraph(sentence_count: 15)}"],
                'total_amount' => [
                    contract.total_amount,
                    contract.total_amount + rand(-5000..5000)
                ]
            }

            # Select 1-2 random keys to include in this modification log
            selected_changes = potential_changes.keys.sample(rand(1..2)).index_with do |key|
                potential_changes[key]
            end

            FactoryBot.create(
                :modification_log,
                contract:,
                modified_by: User.all.sample,
                changes_made: selected_changes,
                modification_type: %w[renew amend].sample,
                status: %w[pending approved rejected].sample
            )
        end

        # Generate Decision History Entries
        10.times do
            FactoryBot.create(
                :contract_decision,
                contract:,
                user: User.all.sample, # Random user making the decision
                decision: ContractStatus.list.sample, # Randomly select a valid decision status
                reason: "Reason for decision #{Faker::Lorem.paragraph(sentence_count: 5)}",
                created_at: Time.zone.now - rand(1..100).days # Random past date
            )
        end
    end

    BvcogConfig.create(
        contracts_path: Rails.root.join('public/contracts'),
        reports_path: Rails.root.join('public/reports')
    )
else
    # ------------ DEV/TEST SEEDS ------------ #
    (1..5).each do |i|
        # Create programs
        FactoryBot.create(
            :program,
            id: i,
            name: "Program #{i}"
        )

        # Create entities
        FactoryBot.create(
            :entity,
            id: i,
            name: "Entity #{i}"
        )
    end

    # Create users
    (1..50).each do |i|
        FactoryBot.create(
            :user,
            id: i,
            level: UserLevel.enumeration.except(:zero).keys.sample,
            program: Program.all.sample,
            entities: Entity.all.sample(rand(1..3))
        )
    end

    # Create Admin
    FactoryBot.create(
        :user,
        email: 'admin@example.com',
        password: 'password',
        first_name: 'Admin',
        last_name: 'User',
        program: Program.all.sample,
        entities: Entity.all.sample(rand(0..Entity.count)),
        level: UserLevel::ONE,
        invitation_accepted_at: Time.zone.now
    )

    # Create Gatekeeper
    FactoryBot.create(
        :user,
        email: 'gatekeeper@example.com',
        password: 'password',
        first_name: 'Gatekeeper',
        last_name: 'User',
        program: Program.all.sample,
        entities: Entity.all.sample(rand(0..Entity.count)),
        level: UserLevel::TWO,
        invitation_accepted_at: Time.zone.now
    )

    # Create User
    FactoryBot.create(
        :user,
        email: 'user@example.com',
        password: 'password',
        first_name: 'Example',
        last_name: 'User',
        program: Program.all.sample,
        entities: Entity.all.sample(rand(0..Entity.count)),
        level: UserLevel::THREE,
        invitation_accepted_at: Time.zone.now
    )

    (1..50).each do |i|
        # Create vendors
        FactoryBot.create(
            :vendor,
            id: i,
            name: "Vendor #{i}"
        )

        # Create Contracts
        d = Time.zone.today + 1.day * i
        statuses = ContractStatus.list.reject { |status| status == :created }
        FactoryBot.create(
            :contract,
            id: i + 151,
            current_type: TYPE[0],
            title: "Contract #{i}",
            entity: Entity.all.sample,
            program: Program.all.sample,
            point_of_contact: User.all.sample,
            vendor: Vendor.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            extension_duration: i.months,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: statuses.sample
        )

        # Create Amendments/Renewals
        d = Time.zone.today + 1.day * i
        statuses = ContractStatus.list.reject { |status| status == :created }
        contract_type = TYPE.select { |type| %w[amend renew].include?(type) }
        selected_type = contract_type.sample

        FactoryBot.create(
            :contract,
            id: i + 201,
            current_type: selected_type,
            title: "#{selected_type.capitalize} #{i}",
            entity: Entity.all.sample,
            program: Program.all.sample,
            point_of_contact: User.all.sample,
            vendor: Vendor.all.sample,
            ends_at: d,
            ends_at_final: d + 1.day * i,
            extension_count: i,
            extension_duration: i.months,
            extension_duration_units: TimePeriod::MONTH,
            contract_status: (statuses - ['approved']).sample
        )
    end

    contact_person = User.find_by(email: 'user@example.com')
    # Create some documents with nearby expiries to test expiring docs mailer
    (1..100).each do |i|
        FactoryBot.create(
            :contract,
            id: 50 + i,
            point_of_contact: contact_person,
            title: "Expiry Contract #{i}",
            program: Program.all.sample,
            vendor: Vendor.all.sample,
            entity: Entity.all.sample,
            ends_at: Time.zone.today + 1.day * i,
            ends_at_final: Time.zone.today + 2.days * i,
            extension_count: i,
            extension_duration: i.months,
            extension_duration_units: TimePeriod::MONTH
        )
    end

    # Create contract documents
    (1..500).each do |i|
        FactoryBot.create(
            :contract_document,
            id: i,
            contract: Contract.all.sample
        )
    end

    # Create vendor reviews manually since they have a (user, vendor) unique index
    used_user_vendor_combos = []
    (1..100).each do |i|
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

    # Reset and generate modification logs/decision histories for approved contracts
    Contract.where(contract_status: ContractStatus::APPROVED).find_each do |contract|
        # Generate Modification Logs
        10.times do
            existing_contract_ids = Contract.pluck(:id)
            new_contract_id = (1..100).to_a.find { |id| !existing_contract_ids.include?(id) }

            # Define potential changes
            potential_changes = {
                'contract_id' => [contract.id, new_contract_id],
                'starts_at' => [
                    (contract.starts_at - rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S'),
                    (contract.starts_at + rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S')
                ],
                'ends_at' => [
                    (contract.ends_at - rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S'),
                    (contract.ends_at + rand(1..6).months).strftime('%Y-%m-%d %H:%M:%S')
                ],
                'summary' => ['Previous Summary', "Updated Summary #{Faker::Lorem.paragraph(sentence_count: 15)}"],
                'total_amount' => [
                    contract.total_amount,
                    contract.total_amount + rand(-5000..5000)
                ]
            }

            # Select 1-2 random keys to include in this modification log
            selected_changes = potential_changes.keys.sample(rand(1..2)).index_with do |key|
                potential_changes[key]
            end

            FactoryBot.create(
                :modification_log,
                contract:,
                modified_by: User.all.sample,
                changes_made: selected_changes,
                modification_type: %w[renew amend].sample,
                status: %w[pending approved rejected].sample
            )
        end

        # Generate Decision History Entries
        10.times do
            FactoryBot.create(
                :contract_decision,
                contract:,
                user: User.all.sample, # Random user making the decision
                decision: ContractStatus.list.sample, # Randomly select a valid decision status
                reason: "Reason for decision #{Faker::Lorem.paragraph(sentence_count: 5)}",
                created_at: Time.zone.now - rand(1..100).days # Random past date
            )
        end
    end

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
