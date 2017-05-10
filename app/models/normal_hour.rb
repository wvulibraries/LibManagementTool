# Normal Hour data model use for validating normal hours.
# @author David J. Davis
# @author Tracy McCormick
class NormalHour < ApplicationRecord
  belongs_to :resource, polymorphic: true

  validates :id, numericality: { only_integer: true, allow_nil: true }
  validates :resource_type, inclusion: { in: %w[library department] }

  validates :open_time, presence: true, allow_blank: false
  validates :close_time, presence: true, allow_blank: false

  validates :day_of_week,
            numericality: {
              only_integer: true,
              greater_than: -1,
              less_than_or_equal_to: 6
            }

  validate :day_of_week_set

  # resource_name
  # @author David J. Davis
  # determines if library or department and returns the name of the resource
  def resource_name
    if resource_type == 'department'
      resource = Department.find(resource_id)
      resource.name + ' - ' + resource.library.name
    else
      resource = Library.find(resource_id)
      resource.name
    end
  end

  # hr_start_time
  # @author David J. Davis
  # @return a human readable time string
  def hr_open_time
    human_readable_time(open_time)
  end

  # hr_close_time
  # @author David J. Davis
  # @return a human readable time string
  def hr_close_time
    human_readable_time(close_time)
  end

  # weekday
  # @author David J. Davis
  # @returns the day of the week Monday, Tuesday, Wed etc.
  def weekday
    day = day_of_week.to_i
    Date::DAYNAMES[day]
  end

  # open_close_time
  # @author Tracy A. McCormick
  # @param time a time string from the database
  # @return string containing both the hr_open_time and hr_end_time
  def open_close_time
    open_time.nil? || close_time.nil? ? '' : hr_open_time + ' - ' + hr_close_time
  end

  # comment
  # @author Tracy A. McCormick
  def comment
    open_time.nil? && close_time.nil? ? 'Closed' : ''
  end

  private

  # human_readable_time
  # @author David J. Davis, Tracy A. McCormick
  # @param time a time string from the database
  # @return a human readable time string
  def human_readable_time(time)
    !time.nil? ? time.strftime('%l:%M %p').strip : ''
  end

  # day_of_week_set
  # @author Tracy McCormick
  # @author David J. Davis (Modified)
  # checks to see if the normal hour exists for that day
  # throws an error in the form if exists
  def day_of_week_set
    check = NormalHour.where.not(id: id).where('resource_id = ?', resource_id).where('resource_type = ?', resource_type).where('day_of_week = ?', day_of_week)
    errors.add(:day_of_week, 'already set') if check.exists?
  end
end
