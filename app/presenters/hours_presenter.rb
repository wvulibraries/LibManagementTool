require 'date'

class HoursPresenter
  DATE_FORMAT = '%m-%d-%Y'.freeze
  API_DATE_FORMAT = '%Y-%m-%d'.freeze

  attr_accessor :date

  # libraries
  # @author David J. Davis
  # @author Tracy A. McCormick
  # @date : 3.27.2017
  # retrieves database record
  # @param - id (int) : nil or int that is the id of the record wanting to be retrieved
  # @return Library database record
  def libraries(id = nil)
    if id.nil?
      Library.includes(:normal_hours).includes(:special_hours).select('id, name')
    else
      Library.includes(:normal_hours).includes(:special_hours).where('id = ?', id)
    end
  end

  # departments
  # @author David J. Davis
  # retrieves database record
  # @param - id (int) : nil or int that is the id of the record wanting to be retrieved
  # @return Library database record
  def departments(id = nil)
    if id.nil?
      Department.includes(:normal_hours).includes(:special_hours).select('id, name')
    else
      Department.includes(:normal_hours).includes(:special_hours).where('id = ?', id).select('id,name')
    end
  end

  # resources_for_list
  # @author David J. Davis
  # @date 3.23.2017
  # @return resources - id and name of a library or department, or both.
  # @todo needs work, right now the list isn't catecatenated together, access
  # with resource[0] and resource[1] if no type provided
  # Generates an array of DB Objects and returns that for iteration later.
  def resources_for_list(id = nil, type = nil)
    resources = []
    if id.present? && type == 'library'
      resources << (libraries id)
    elsif type == 'library'
      resources << libraries
    elsif id.present? && type == 'department'
      resources << (departments id)
    elsif type == 'department'
      resources << departments
    else
      resources << departments
      resources << libraries
    end
    resources
  end

  # find_normal_hours
  # @author David J. Davis
  # @author Tracy A. McCormick
  # @date 3.24.2017
  # @param - date (date): sets to today by default
  # @param - resource (hash): sets type and id, doesn't have to exist
  # @return var (type) - description
  # gets the normal hours from the database
  def find_normal_hours(resource)
    resource.normal_hours.each do |hour|
      next unless hour.day_of_week == Date.strptime(@date, DATE_FORMAT).wday
      return { open_time: hour.hr_open_time,
               close_time: hour.hr_close_time,
               open_close_time: hour.open_close_time,
               comment: hour.comment }
    end
    { open_time: nil, close_time: nil, open_close_time: nil, comment: 'Closed' }
  end

  # @author Tracy A. McCormick
  # @date 4.26.2017
  # @param - start_date (string), end_date (string)
  # @return boolean
  # converts date string to date object and checks if current date set in @date
  # is in that range.
  def date_in_range(start_date, end_date)
    Date.strptime(@date, DATE_FORMAT).between?(Date.parse(start_date), Date.parse(end_date))
  end

  # special_hour_exists
  # @author David J. Davis
  # @date 3.23.2017
  # @author Tracy A. McCormick
  # @param date (date): sets to today by default
  # @param resource (hash): sets type and id, doesn't have to exist
  # @return (boolean) - true or false of existance
  # checks if a record exists
  def special_hours_exists?(resource)
    return false unless resource.special_hours.count > 0
    resource.special_hours.each do |hour|
      next unless date_in_range(hour.start_date.to_s, hour.end_date.to_s)
      return true
    end
    false
  end

  # find_special_hours
  # @author David J. Davis
  # @author Tracy A. McCormick
  # @date 3.27.2017
  # @param - date (date): sets to today by default
  # @param - resource (hash): sets type and id, doesn't have to exist
  # @return (boolean) - the record from database
  # gets the special hours from the database
  def find_special_hours(resource)
    resource.special_hours.each do |hour|
      next unless date_in_range(hour.start_date.to_s, hour.end_date.to_s)
      return { open_time: hour.hr_open_time,
               close_time: hour.hr_close_time,
               open_close_time: hour.open_close_time,
               comment: hour.comment }
    end
    { open_time: nil, close_time: nil, open_close_time: nil, comment: nil }
  end

  # find_hours
  # @author Tracy A. McCormick
  # @date 4.26.2017
  # @param - item: item is a object of either library or department
  # @return hash - containing open_time, close_time and a comment
  # gets the normal hours from the database
  def find_hours(item)
    return find_special_hours(item) if special_hours_exists?(item)
    find_normal_hours item
  end
end
