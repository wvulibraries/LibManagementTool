# Special Hour model this is used for adding special hours to the projects
# versus consistent hours from normal hours.
# @author David J. Davis
# @author Tracy McCormick
class SpecialHour < ApplicationRecord
  belongs_to :special, polymorphic: true

  validates :special_id, numericality: { only_integer: true, allow_nil: false }
  validates :special_type, inclusion: { in: %w[library department] }
  validates :id, numericality: { only_integer: true, allow_nil: true }

  # hr_start_date
  # @author David J. Davis
  # @return a human readable date string 
  def hr_start_date
    hr_date(start_date)
  end

  # hr_end_date
  # @author David J. Davis
  # @return a human readable date string 
  def hr_end_date
    hr_date(end_date)
  end

  # hr_start_time
  # @author David J. Davis
  # @return a human readable time string 
  def hr_open_time
    hr_time(open_time)
  end

  # hr_close_time
  # @author David J. Davis
  # @return a human readable time string 
  def hr_close_time
    hr_time(close_time)
  end

  # get resource 
  # @author David J. Davis
  # @return a human readable time string 
  def get_resource
    if special_type == 'department'
      special = Department.find(special_id)
      special.name + ' - ' + special.library.name
    else
      special = Library.find(special_id)
      special.name
    end
  end

  private

  # hr_time
  # @param time : a time string from db
  # @author David J. Davis
  # @return a human readable time string as 12 hour minute am/pm
  def hr_time(time)
    if !time.nil?
      time.strftime('%l:%M %p')
    else
      ''
    end
  end

  # hr_time
  # @param date : a datetime string from db
  # @author David J. Davis
  # @return a human readable date as full month day, year.  
  def hr_date(date)
    if !date.nil?
      date.strftime('%B %d, %Y')
    else
      ''
    end
  end

end
