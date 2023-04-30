
namespace :contracts do
  desc 'Send expiry reminders for contracts'
  task send_expiration_reminders: :environment do
    [10, 30, 60, 90].each do |days_to_expiration|
      # Get contracts that are due to expire in exactly days_to_expiration days
      contracts = Contract.where('ends_at = ?', Date.today + days_to_expiration.days)
      contracts.each do |contract|
        contract.send_expiry_reminder
      end
    end
  end

  desc 'Send automated expiration reports for contracts'
  task send_expiration_reports: :environment do
    # Create a new report 
    report = Report.new(title: "Contract Expiration Report - #{Date.today.strftime("%m/%d/%Y")}", report_type: ReportType::CONTRACTS)
    # Use the admin user as the user who generated the report
    report.user_id = User.find_by(email: Rails.env.production? ? 'admin@bvcogdev.com': 'admin@example.com').id
    report.generate_contract_expiration_report
    report.save
    ContractMailer::expiration_report(report).deliver_now

    # Delete the report ID to prevent access to the report
    report.delete
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
