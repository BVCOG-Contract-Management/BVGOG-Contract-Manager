
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
