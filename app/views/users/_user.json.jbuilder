json.extract! user, :id, :first_name, :last_name, :email, :program_id, :program_manager, :status, :redirect_user_id, :level, :created_at, :updated_at
json.url user_url(user, format: :json)
