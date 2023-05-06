# Sends reminder emails for contract expiry
class ContractMailer < ApplicationMailer
  def expiry_reminder(contract)
    @contract = contract
    program_manager = contract.point_of_contact
    days_remaining = (contract.ends_at.to_datetime - Date.today.to_datetime).to_i
    mail(to: [contract.point_of_contact.email, program_manager.email],
         subject: "REMINDER: Contract expiring in #{days_remaining} days ")
  end
end
