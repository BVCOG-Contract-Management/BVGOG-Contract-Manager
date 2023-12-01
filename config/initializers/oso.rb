# frozen_string_literal: true

OSO = Oso.new
ActiveSupport::Reloader.to_prepare do
    OSO.register_class(User, fields: { id: :integer })
    OSO.register_class(Contract, fields: { id: :integer })
    OSO.load_files(['app/rbac/main.polar'])
rescue StandardError => e
    # :nocov:
    Rails.logger.debug e.class
    # :nocov:
end
