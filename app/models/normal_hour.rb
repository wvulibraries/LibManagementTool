class NormalHour < ApplicationRecord
  belongs_to :resource, polymorphic: true

  def get_resource
    if self.resource_type == "department"
        resource = Department.find(self.resource_id)
        return resource.name + " - " + resource.library.name
    else
        resource = Library.find(self.resource_id)
        return resource.name
    end
  end

  def hr_open_time
    return human_readable_time(self.open_time)
  end

  def hr_close_time
    return human_readable_time(self.close_time)
  end

  def weekday
    day = self.day_of_week.to_i
    return Date::DAYNAMES[day]
  end

  private
    def human_readable_time(time)
      if time != nil
          return time.strftime("%l:%M %p")
      else
          return ""
      end
    end
end
