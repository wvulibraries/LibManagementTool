class Department < ApplicationRecord
  belongs_to :library, inverse_of: :departments
  has_many :normal_hours, as: :resource
  has_many :special_hours, as: :special

  def reformat_name
    return self.name + " - " + self.library.name
  end
end
