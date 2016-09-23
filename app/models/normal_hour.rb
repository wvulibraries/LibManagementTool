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
    if self.open_time != nil
        return self.open_time.strftime("%l : %M %P")
    else
        return "- -"
    end
  end

  def hr_close_time
    if self.close_time != nil
        return self.close_time.strftime("%l : %M %P")
    else
        return "- -"
    end
  end
end
