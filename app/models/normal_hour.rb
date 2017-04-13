# Normal Hour data model use for validating normal hours.
# @author David J. Davis
# @author Tracy McCormick
class NormalHour < ApplicationRecord
  belongs_to :resource, polymorphic: true

  validates :id,  numericality: { only_integer: true, allow_nil: true }
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

  def get_resource
    if resource_type == 'department'
      resource = Department.find(resource_id)
      resource.name + ' - ' + resource.library.name
    else
      resource = Library.find(resource_id)
      resource.name
    end
  end

  def hr_open_time
    human_readable_time(open_time)
  end

  def hr_close_time
    human_readable_time(close_time)
  end

  def weekday
    day = day_of_week.to_i
    Date::DAYNAMES[day]
  end

  private

  def human_readable_time(time)
    if !time.nil?
      time.strftime('%l:%M %p').strip
    else
      ''
    end
  end

  def day_of_week_set
    check = NormalHour.where.not(id: id).where('resource_id = ?', resource_id).where('resource_type = ?', resource_type).where('day_of_week = ?', day_of_week)
    errors.add(:day_of_week, 'already set') if check.exists?
  end
end
