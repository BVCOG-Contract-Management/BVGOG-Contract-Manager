# frozen_string_literal: true

# :nocov:
# Handdles sending e mails to users.
class ApplicationMailer < ActionMailer::Base
    layout 'mailer'

    # Set attachments for all emails
    before_action :add_inline_attachments!

    private

    # Set attachments for all emails
    def add_inline_attachments!
        attachments.inline['bvcog-logo.png'] = File.read("#{Rails.root}/app/assets/images/bvcog-logo.png")
    end
end
# :nocov:
