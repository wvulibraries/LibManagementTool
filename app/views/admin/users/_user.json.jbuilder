json.extract! user, :id, :username, :firstname, :lastname, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)