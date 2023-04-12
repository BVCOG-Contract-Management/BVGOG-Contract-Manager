# Sends reminder emails for contract expiry
class ContractMailer < ApplicationMailer
  def expiry_reminder(contact_person, program_manager, contract, days)
    @contract = contract
    @days = days
    mail(to: [contact_person.email, program_manager.email], subject: "REMINDER: Contract expiring in #{days} days ")
  end
end
