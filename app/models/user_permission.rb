# User Permissions
# @author David J. Davis
# User permissions gives attributes to use for determining the ability of a user
# to edit normal hours or special hours based on libraries or departments
# also ensures that they can only change libraries or departments that they have
# access too. 
class UserPermission < ApplicationRecord
  belongs_to :user
  validates_presence_of :username
  serialize :libraries, Array
  serialize :departments, Array
end
