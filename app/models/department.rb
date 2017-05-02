# Department model for keeping track of libraries sub departments
# @author David J. Davis
# @author Tracy McCormick
class Department < ApplicationRecord
  belongs_to :library, inverse_of: :departments
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special

  validates :name, presence: true
  validates :id, numericality: { only_integer: true, allow_nil: true }
  validates :library_id, numericality: {
    only_integer: true,
    allow_nil: false,
    message: '%{value} must not be nil and must be an valid id.'
  }
  validates :description, length: {
    maximum: 500,
    message: '%{value} is too long, \
    please shorten the description to 500 characters.'
  }, allow_blank: true

  # Scope is used in the view to get only departments of with these items
  # example: Departments.sorted
  scope :lib_sorted, (-> { order('library_id ASC') })

  # Formats department name to also show their library.
  # Eliminates confusing like named departments in different libraries.
  # @author David J. Davis
  def reformat_name
    name + ' - ' + library.name
  end
end
