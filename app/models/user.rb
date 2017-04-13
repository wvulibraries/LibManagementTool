# User
# @author David J. Davis
# Allows users to be added to the system.
# This only works for CAS users at the current time
class User < ApplicationRecord
  validates_presence_of :username, :firstname, :lastname
  validates :admin, inclusion: { in: [true, false] }
  has_one :user_permissions
end
