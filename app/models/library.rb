# Library data model.
# @author David J. Davis
# @author Tracy McCormick
class Library < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special

  validates :name, presence: true
  validates :id, numericality: { only_integer: true, allow_nil: true }
  validates :description,
            length: {
              maximum:  500,
              message: '%{value} is too long, shorten to 500 characters.'
            },
            allow_blank: true

  # returns a list of departments, unless the library has no departments.
  # @author David J. Davis
  def opt_groups
    return unless departments.empty?
  end
end
