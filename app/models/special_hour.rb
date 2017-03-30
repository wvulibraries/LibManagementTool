class SpecialHour < ApplicationRecord
  belongs_to :special, polymorphic: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }
  validates :start_date, presence: true, allow_blank: false
  validates :end_date, presence: true, allow_blank: false
  validates :open_time, presence: true, allow_blank: false
  validates :close_time, presence: true, allow_blank: false

  validate :special_set

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

  def get_resource
    if self.special_type == "department"
        special = Department.find(self.special_id)
        special.name + " - " + special.library.name
    elsif
        special = Library.find(self.special_id)
        special.name
    end
  end

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

    def special_set
      #check if start_date overlaps anything currently set
      check = SpecialHour.where("special_id = ?", special_id).where("special_type = ?", special_type).where("start_date <= ?", start_date).where("end_date >= ?", start_date)

      if check.exists?
        errors.add(:start_date, "overlaps currently set special hour.")
      end

      #check if end_date overlaps anything currently set
      check = SpecialHour.where("special_id = ?", special_id).where("special_type = ?", special_type).where("start_date <= ?", end_date).where("end_date >= ?", end_date)

      if check.exists?
        errors.add(:end_date, "overlaps currently set special hour.")
      end
    end
end
