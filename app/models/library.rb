class Library < ApplicationRecord
  has_many :departments, dependent: :destroy

  def departments
      departments = Department.where(:library_id => self.id)
  end
end
