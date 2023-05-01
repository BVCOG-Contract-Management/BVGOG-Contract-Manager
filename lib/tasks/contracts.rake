
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
    headers = [
      'ID',
      'Title',
      'Description',
      'Key Words',
      'Entity Name',
      'Program Name',
      'Point of Contact',
      'Vendor',
      'Start Date',
      'End Date',
      'Amount',
      'Initial Term',
      'Contract Type',
      'Contract Status',
      'End Trigger',
      'Created At',
      'Updated At'
    ]
    contracts = Contract.all
    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
      contracts.each do |contract|
        csv << [
          contract.id,
          contract.title,
          contract.description,
          contract.key_words,
          contract.entity.name,
          contract.program.name,
          contract.point_of_contact.full_name,
          contract.vendor.name,
          contract.starts_at.strftime("%m/%d/%Y"),
          contract.ends_at.strftime("%m/%d/%Y"),
          "$#{contract.amount_dollar.round(2)} per #{contract.amount_duration}",
          "$#{contract.initial_term_amount.round(2)} per #{contract.initial_term_duration}",
          contract.contract_type.humanize,
          contract.contract_status.humanize,
          contract.end_trigger.humanize,
          contract.created_at.strftime("%m/%d/%Y"),
          contract.updated_at.strftime("%m/%d/%Y")
        ]
      end
    end
    file_name = "bvcog-auto-contracts-export-#{Date.today.strftime("%m-%d-%Y")}.csv"
    File.write(File.join(BvcogConfig.last.reports_path, file_name), csv_data)
  end

  # Test task for heroku
  desc 'Test task'
  task test: :environment do
    # Create a dummy contract
    contract = Contract.new(
      title: "Test Contract Heroku #{SecureRandom.hex(5)}",
      description: "Test Contract Heroku",
      key_words: "[\"Test\", \"Contract\", \"Heroku\"]",
      entity_id: Entity.all.sample.id,
      program_id: Program.all.sample.id,
      point_of_contact_id: User.where(email: 'admin@bvcogdev.com').first.id,
      vendor_id: Vendor.all.sample.id,
      starts_at: Date.today,
      ends_at: Date.today + 1.year,
      amount_dollar: 100,
      amount_duration: TimePeriod::MONTH,
      initial_term_amount: 100,
      initial_term_duration: TimePeriod::MONTH,
      contract_type: ContractType::GRANT,
      contract_status: ContractStatus::IN_PROGRESS,
      end_trigger: EndTrigger::LIMITED_TERM,
      created_at: Date.today,
      updated_at: Date.today
    )
    contract.save
  end
end
