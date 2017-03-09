class NormalHour < ApplicationRecord
  belongs_to :resource, polymorphic: true

  validates :id,  numericality: { only_integer: true, allow_nil: true }
  validates :day_of_week, numericality: { only_integer: true, :greater_than => -1, :less_than_or_equal_to => 6 }
  validates :resource_type, inclusion: { in: ['library', 'department'] }
  validates :open_time, presence: true, allow_blank: false
  validates :close_time, presence: true, allow_blank: false

  def get_resource
    if self.resource_type == "department"
        resource = Department.find(self.resource_id)
        resource.name + " - " + resource.library.name
    elsif
        resource = Library.find(self.resource_id)
        resource.name
    end
  end

  def hr_open_time
     human_readable_time(self.open_time)
  end

  def hr_close_time
     human_readable_time(self.close_time)
  end

  def weekday
    day = self.day_of_week.to_i
     Date::DAYNAMES[day]
  end

  private
    def human_readable_time(time)
      if time != nil
           time.strftime("%l:%M %p").strip
      else
           ""
      end
    end
end
