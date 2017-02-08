json.extract! admin_user_permission, :id, :username, :libraries, :departments, :created_at, :updated_at
json.url admin_user_permission_url(admin_user_permission, format: :json)