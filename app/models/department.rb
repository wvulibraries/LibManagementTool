class Department < ApplicationRecord
  belongs_to :library, inverse_of: :departments
end
