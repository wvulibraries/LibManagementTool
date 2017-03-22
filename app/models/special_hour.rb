class SpecialHour < ApplicationRecord
  belongs_to :special, polymorphic: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }

  def hr_start_date
     hr_date(self.start_date)
  end

  def hr_end_date
     hr_date(self.end_date)
  end

  def hr_open_time
     hr_time(self.open_time)
  end

  def hr_close_time
     hr_time(self.close_time)
  end

  # def open_24
  #    self.open_24
  # end

  private
    def hr_time(time)
      if time != nil
           time.strftime("%l:%M %p")
      else
           ""
      end
    end

    def hr_date(date)
      if date != nil
           date.strftime("%B %d, %Y")
      else
           ""
      end
    end
end
