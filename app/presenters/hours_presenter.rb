class HoursPresenter
  DATE_FORMAT = '%m-%d-%Y'.freeze
  API_DATE_FORMAT = '%Y-%m-%d'.freeze

  def initialize
    @rss_array = []
  end

  # libraries
  # ==================================================
  # Name : David J. Davis
  # Date :
  # Modified : Tracy A. McCormick
  # Date : 3.27.2017
  #
  # Description: retrieves database record
  #
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
  # ==================================================
  # Name : David J. Davis
  # Date :
  #
  # Description: retrieves database record
  #
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
  # ==================================================
  # Name : David J. Davis
  # Date : 3.23.2017
  #
  # Description: Generates an array of DB Objects and returns that for iteration later.
  #
  # @return resources - id and name of a library or department, or both.
  # @todo needs work, right now the list isn't catecatenated togather, access
  # with resource[0] and resource[1] if no type provided

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

  # get_resource_name
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/28/2017
  #
  # Description: returns either the Library name or combined department name &
  # library name
  def get_resource_name(hash = {})
    if hash[:type] == 'department'
      resource = Department.find(hash[:id])
      resource.name + ' - ' + resource.library.name
    else
      resource = Library.find(hash[:id])
      resource.name
    end
  end

  # get_special hours
  # ==================================================
  # Name : David J. Davis
  # Date : 3.23.2017
  # Modified : Tracy A. McCormick
  # Date : 3.27.2017
  #
  # Description: gets the special hours from the database
  #
  # @param - date (date): sets to today by default
  # @param - resource (hash): sets type and id, doesn't have to exist
  # @return (boolean) - the record from database

  def get_special_hours(date = Date.today, resource = {})
    date = date.beginning_of_day
    if resource[:type].present? && resource[:id].present?
      SpecialHour.where(special_type: resource[:type]).where(special_id: resource[:id]).where("start_date <= ? AND end_date >= ?", date, date)
    else
      SpecialHour.where('start_date <= ? AND end_date >= ?', date, date)
    end
  end

  # get_normal_hours
  # ==================================================
  # Name : David J. Davis
  # Date :
  # Modified : Tracy A. McCormick
  # Date : 3.24.2017
  #
  # Description: gets the normal hours from the database
  #
  # @param - date (date): sets to today by default
  # @param - resource (hash): sets type and id, doesn't have to exist
  # @return var (type) - description

  def get_normal_hours(date = Date.today, resource = {})
    date = date.beginning_of_day
    if resource[:type].present? && resource[:id].present?
      NormalHour.where(resource_type: resource[:type]).where(resource_id: resource[:id]).where(day_of_week: date.wday)
    else
      NormalHour.where(day_of_week: date.wday)
    end
  end

  # get_day
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Checks for special_hour exists for the date and resource if none are found
  # returns normal hours for the date and resource supplied.
  def get_day(date = Date.today, resource = {})
    if special_hour_exists?(date, resource)
      get_special_hours(date, resource)
    else
      get_normal_hours(date, resource)
    end
  end

  # get_date
  # ==================================================
  # Name : Tracy McCormick
  # Date : 04/05/2017
  #
  # Description: Calls get_day and returns a hash formatted for the date and resource requested.
  # if no results are returned from get_day a Closed message is returned in the hash.
  def get_date(resource)
    date = Date.parse(resource[:date])
    get_day(date, resource).each do |hour|
      if hour.open_time.present? && hour.close_time.present?
        return { open_time: hour.hr_open_time, close_time: hour.hr_close_time, comment: '' }
      elsif hour.close_time.present? && hour.no_open_time
        return { open_time: '', close_time: hour.hr_close_time, comment: 'No Open Time' }
      elsif hour.open_time.present? && hour.no_close_time
        return { open_time: hour.hr_open_time, close_time: '', comment: 'No Close Time' }
      elsif hour.class.to_s == 'SpecialHour' && hour.open_24
        return { open_time: '', close_time: '', comment: 'Open 24 Hours' }
      end
    end

    { open_time: '', close_time: '', comment: 'Closed' }
  end

  #  special_hour_exists
  # ==================================================
  # Name : David J. Davis
  # Date :  3.23.2017
  # Modified : Tracy A. McCormick
  # Date : 3.27.2017
  #
  # Description: checks if a record exists
  #
  # @param - date (date): sets to today by default
  # @param - resource (hash): sets type and id, doesn't have to exist
  # @return (boolean) - true or false of existance

  def special_hour_exists?(date = Date.today, resource = {})
    date = date.beginning_of_day
    if resource[:type].present? && resource[:id].present?
      SpecialHour.where(special_type: resource[:type]).where(special_id: resource[:id]).where('start_date <= ? AND end_date >= ?', date, date).exists?
    else
      SpecialHour.where('start_date <= ? AND end_date >= ?', date, date).exists?
    end
  end
end
