class Library < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special
end
