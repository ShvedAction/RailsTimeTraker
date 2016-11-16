json.extract! user, :id, :login, :password, :auth_type, :created_at, :updated_at
json.url user_url(user, format: :json)