class Library < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :normal_hours, as: :resource
end
