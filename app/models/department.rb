class Department < ApplicationRecord
  belongs_to :library, inverse_of: :departments
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special

  validates :name, presence: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }
  validates :library_id,  numericality: { only_integer: true, allow_nil: false, message: "%{value} must not be nil and must be an valid id." }
  validates :description, length: { maximum: 500, message: "%{value} is too long, please shorten the description to 500 characters." }, allow_blank: true


  def reformat_name
    return self.name + " - " + self.library.name
  end
end
