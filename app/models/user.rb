class User < ApplicationRecord
    # Add associations here
    has_one :redirect_user, class_name: 'User', foreign_key: 'redirect_user_id'
end
