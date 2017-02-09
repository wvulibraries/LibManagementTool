class UserPermission < ApplicationRecord
  belongs_to :user
  serialize :libraries, Array
  serialize :departments, Array
end
