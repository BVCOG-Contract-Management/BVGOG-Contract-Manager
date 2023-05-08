OSO = Oso.new
ActiveSupport::Reloader.to_prepare do
    begin
        OSO.register_class(User, fields: {id: :integer})
        OSO.register_class(Contract, fields: {id: :integer})
        OSO.load_files(["app/rbac/main.polar"])
    rescue => e
        print e.class
    end
end