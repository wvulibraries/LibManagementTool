class SpecialHour < ApplicationRecord
  belongs_to :special, polymorphic: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }

  def hr_start_date
    return hr_date(self.start_date)
  end

  def hr_end_date
    return hr_date(self.end_date)
  end

  def hr_open_time
    return hr_time(self.open_time)
  end

  def hr_close_time
    return hr_time(self.close_time)
  end

  private
    def hr_time(time)
      if time != nil
          return time.strftime("%l:%M %p")
      else
          return ""
      end
    end

    def hr_date(date)
      return date.strftime("%B %d, %Y")
    end
end
