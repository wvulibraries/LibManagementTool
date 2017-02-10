class UserPermission < ApplicationRecord
  belongs_to :user
  validates_presence_of :username
  serialize :libraries, Array
  serialize :departments, Array
end
