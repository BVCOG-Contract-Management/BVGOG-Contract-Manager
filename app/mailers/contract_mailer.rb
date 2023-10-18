# frozen_string_literal: true

# :nocov:
# Sends reminder emails for contract expiry
class ContractMailer < ApplicationMailer
  def expiry_reminder(contract)
    @contract = contract
    # We may have multiple program managers, so we need to get all of their emails
    program_manager_emails = User.where(program: contract.program, is_program_manager: true).pluck(:email)
    days_remaining = (contract.ends_at.to_datetime - Date.today.to_datetime).to_i

    emails = [contract.point_of_contact.email, program_manager_emails].flatten
    mail(to: emails,
         subject: "REMINDER: Contract expiring in #{days_remaining} days ")
  end

  def expiration_report(report)
    @report = report
    attachments[report.file_name] = File.read(report.full_path)
    BvcogConfig.last.users.each do |user|
      mail(
        to: user.email,
        subject: "Contract Expiration Report - #{Date.today.strftime('%m/%d/%Y')}"
      ) do |format|
        format.html { render 'expiration_report', locals: { name: user.full_name } }
      end
    end
  end
end
# :nocov:
