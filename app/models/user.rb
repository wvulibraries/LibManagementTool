class User < ApplicationRecord
  validates_presence_of :username, :firstname, :lastname
  validates :admin, inclusion: { in: [true, false] } # makes sure that null is not an option
end
