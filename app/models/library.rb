class Library < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special

  validates :name, presence: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }
  validates :description, length: { maximum: 500, message: "%{value} is too long, please shorten the description to 500 characters." }, allow_blank: true

  def opt_groups
    return unless self.departments.empty?
  end 
end
