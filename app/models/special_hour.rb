require 'date'
require 'time'
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

  # open_close_time
  # @author Tracy A. McCormick
  # @param time a time string from the database
  # @return string containing both the hr_open_time and hr_end_time
  def open_close_time
    !open_time.nil? && !close_time.nil? ? hr_open_time + ' - ' + hr_close_time : ''
  end

  # comment
  # @author Tracy A. McCormick
  # @return a comment string
  def comment
    if open_24 then 'Open 24 Hours'
    elsif no_open_time then 'no open time set'
    elsif no_close_time then 'no close time set'
    else ''
    end
  end

  # get resource
  # @author David J. Davis
  # @return a human readable time string
  def resource_name
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
  # @author David J. Davis, Tracy A. McCormick
  # @return a human readable time string as 12 hour minute am/pm
  def hr_time(time)
    !time.nil? ? time.strftime('%l:%M %p') : ''
  end

  # hr_time
  # @param date : a datetime string from db
  # @author David J. Davis, Tracy A. McCormick
  # @return a human readable date as full month day, year.
  def hr_date(date)
    !date.nil? ? date.strftime('%B %d, %Y') : ''
  end
end
