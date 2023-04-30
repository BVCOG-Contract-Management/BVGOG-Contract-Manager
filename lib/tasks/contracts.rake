namespace :contracts do
  desc 'Send expiry reminders for contracts'
  task send_expiration_reminders: :environment do
    [10, 30, 60, 90].each do |days|
      start_date = Date.today + days.days
      end_date = start_date + 1.day
      contracts = Contract.where('ends_at >= ? AND ends_at < ?', start_date, end_date)
      puts contracts.all.inspect
      contracts.each do |contract|
        contact_person = contract.point_of_contact
        # TODO: Fix this
        # Don't have program_manager set up yet
        program_manager = contract.point_of_contact
        # program_manager = contract.program_manager@contract.
        # contract.send_expiry_email
        # contract.send_expiry_email_action_contract_path
        contract.send_expiry_reminder
        # ContractMailer.expiry_reminder(contact_person, program_manager, contract, days).deliver_now
      end
    end
  end
end

require 'csv'

namespace :contracts do
  desc 'Export contracts'
  task export_all_contract_data: :environment do
    headers = %w[id title description key_words entity_id entity_name program_id program_name
                 point_of_contact_id point_of_contact_name vendor_id vendor_name starts_at ends_at
                 amount_dollar initial_term_amount contract_type contract_status amount_duration
                 initial_term_duration end_trigger created_at updated_at]
    contracts = Contract.all
    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
      contracts.each do |contract|
        csv << [contract.id, contract.title, contract.description, contract.key_words, contract.entity_id,
                contract.entity.name, contract.program_id, contract.program.name, contract.point_of_contact_id,
                "#{contract.point_of_contact.first_name} #{contract.point_of_contact.last_name}",
                contract.vendor_id, contract.vendor.name, contract.starts_at, contract.ends_at,
                contract.amount_dollar, contract.initial_term_amount, contract.contract_type,
                contract.contract_status, contract.amount_duration, contract.initial_term_duration,
                contract.end_trigger, contract.created_at, contract.updated_at]
      end
    end
    # TODO: Set using admin panel
    current_date = Date.today
    save_path = "contract_csvs/contracts_#{current_date}.csv"
    File.write(save_path, csv_data)
  end
end
