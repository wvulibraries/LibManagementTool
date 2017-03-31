class SpecialHour < ApplicationRecord
  belongs_to :special, polymorphic: true
  validates :id,  numericality: { only_integer: true, allow_nil: true }

  validate :check_start_date
  validate :check_end_date

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

    # check_start_date
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 3/30/2017
    #
    # Description:
    # Throws an error if the start_date is already set in another special_hour for this resource.
    def check_start_date
      #check if start_date overlaps anything currently set
      check = SpecialHour.where.not(id: id).where("special_id = ?", special_id).where("special_type = ?", special_type).where("start_date <= ?", start_date).where("end_date >= ?", start_date)

      if check.exists?
        errors.add(:start_date, "overlaps currently set special hour.")
      end
    end

    # check_end_date
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 3/30/2017
    #
    # Description:
    # Throws an error if the end_date is already set in another special_hour for this resource.
    def check_end_date
      #check if end_date overlaps anything currently set
      check = SpecialHour.where.not(id: id).where("special_id = ?", special_id).where("special_type = ?", special_type).where("start_date <= ?", end_date).where("end_date >= ?", end_date)

      if check.exists?
        errors.add(:end_date, "overlaps currently set special hour.")
      end
    end
end
