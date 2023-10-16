# frozen_string_literal: true

class DeviseCustomMailer < Devise::Mailer
  before_action :add_inline_attachments!

  def confirmation_instructions(record, token, opts = {})
    super
  end

  def reset_password_instructions(record, token, opts = {})
    super
  end

  def unlock_instructions(record, token, opts = {})
    super
  end

  def invitation_instructions(record, token, opts = {})
    super
  end

  private

  def add_inline_attachments!
    attachments.inline['bvcog-logo.png'] = File.read("#{Rails.root}/app/assets/images/bvcog-logo.png")
  end
end
