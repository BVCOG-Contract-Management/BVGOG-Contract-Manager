OSO = Oso.new
ActiveSupport::Reloader.to_prepare do
    begin
        OSO.register_class(User, fields: {id: :integer})
        OSO.register_class(Contract, fields: {id: :integer})
    rescue => e
        if e.class == Oso::DuplicateClassAliasError
            # Do nothing
        else
            raise e
        end
    end

    OSO.load_files(["app/rbac/main.polar"])
end