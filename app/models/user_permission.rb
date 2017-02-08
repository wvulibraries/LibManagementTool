class UserPermission < ApplicationRecord
  belongs_to :user
  serialize :libraries
  serialize :departments
end
