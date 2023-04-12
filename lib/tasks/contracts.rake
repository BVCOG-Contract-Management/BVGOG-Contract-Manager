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
        # program_manager = contract.program_manager
        ContractMailer.expiry_reminder(contact_person, program_manager, contract, days).deliver_now
      end
    end
  end
end
