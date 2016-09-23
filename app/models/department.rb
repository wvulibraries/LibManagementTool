class Department < ApplicationRecord
  belongs_to :library, inverse_of: :departments
  has_many :normal_hours, as: :resource

  def reformat_name
    return self.name + " - " + self.library.name
  end
end
