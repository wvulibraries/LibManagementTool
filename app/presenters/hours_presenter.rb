# app/presenters/hours_presenter.rb

# Hours Presenter
# ==================================================
# AUTHORS : Tracy A. McCormick && David J. Davis
# Description:
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder

require 'date'

class HoursPresenter

  def initialize(params = {})
    @params = self.set_params params
    @date_format = '%m-%d-%Y'
    @hours_array = Array.new
  end

  def set_params(params)
    @params = self.validated_params params
  end

  def get_params
    @params
  end

  # get_hours
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: get hours verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  # @param - params (object) - params object given from the url and by rails
  # @return (array) - list of hours

  def get_hours
   # check and see if date_start and date end are set_params
   if @params[:date_start] && @params[:date_end]
     # call get_hours_list to create the hours_array list
     (format_date(@params[:date_start])..format_date(@params[:date_end])).each do |day|
       get_day_list(day)
     end
   elsif @params[:date_start]
    # if only date_start is present call get_day
    # to populate the hours_array with items for that day
     get_day_list(format_date(@params[:date_start]))
   else
     get_day_list(Date.today)
   end
   # return array back to the calling jbuilder
   @hours_array
  end

  # format_date
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/27/2017
  #
  # Description: converts date string to a Ruby date object
  def format_date(date)
   Date.strptime(date, @date_format)
  end

  # array_push
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/27/2017
  #
  # Description: takes the passed hash and pushs the values to the hours_array
  def array_push(hash)
    @hours_array.push({
      name: hash[:name],
      date: hash[:date],
      open_time: hash[:open_time],
      close_time: hash[:close_time],
      comment: hash[:comment]
    })
  end

  # get_resource_name
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/28/2017
  #
  # Description: returns either the Library name or combined department name & library name
  def get_resource_name(hash = {})
    if hash[:type] == "department"
        resource = Department.find(hash[:id])
        resource.name + " - " + resource.library.name
    elsif
        resource = Library.find(hash[:id])
        resource.name
    end
  end

  # get_hours
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: gets available resources and checks each one calliing get_day
  # to see if hours are set for the resource on the date passed in params. If
  # found calls array_push and sets the hours if no hours are found it pushs
  # closed for that requested day.
  # @param - date (date): sets to today by default

  def get_day_list(date = Date.today)
    resources_for_list.each do |resource|
       resource.each do |item|
         found = false
         hash = {id: item.id, type: resource.name.downcase, date: date.strftime('%Y-%m-%d')}
         day = get_date(hash)
         array_push({name: get_resource_name(hash), date: date.strftime(@date_format), open_time: day[:open_time], close_time: day[:close_time], comment: day[:comment]})
       end
    end
  end

  def get_date(resource)
    date = Date.parse(resource[:date])
    found = false
    get_day(date, resource).each do |hour|
      if hour.open_time.present? && hour.close_time.present?
        return {open_time: hour.hr_open_time, close_time: hour.hr_close_time, comment: ''}
      elsif hour.close_time.present? && hour.no_open_time
        return {open_time: '', close_time: hour.hr_close_time, comment: 'No Open Time'}
      elsif hour.open_time.present? && hour.no_close_time
        return {open_time: hour.hr_open_time, close_time: '', comment: 'No Close Time'}
      elsif hour.open_24
        return {open_time: '', close_time: '', comment: 'Open 24 Hours'}
      end

      found = true
    end

    if !found
      return {open_time: '', close_time: '', comment: 'Closed'}
    end

  end

  # validated_params
  # ==================================================
  # Name : David J. Davis
  # Date :  3.22.2017
  #
  # Description: Removes all parameters that are not in the whitelist
  # of allowed parameters.
  # @param - params (object) - params object given from the url and by rails
  # @return (object) - cleaned object of params that are allowed removes - not allowed params

  def validated_params(params)
    allowed_keys = ['id', 'type', 'date_start', 'date_end']
    clean_params = params.select {|key,value| allowed_keys.include?(key)}
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
      SpecialHour.where(special_type: resource[:type]).where(special_id: resource[:id]).where("start_date <= ? AND end_date >= ?", date, date).exists?
    else
      SpecialHour.where("start_date <= ? AND end_date >= ?", date, date).exists?
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
      SpecialHour.where("start_date <= ? AND end_date >= ?", date, date)
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


  # get_libraries
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

  def get_libraries(id = nil)
    if id === nil
      Library.select('id, name')
    else
      Library.where('id = ?', id)
    end
  end

  # get_departments
  # ==================================================
  # Name : David J. Davis
  # Date :
  #
  # Description: retrieves database record
  #
  # @param - id (int) : nil or int that is the id of the record wanting to be retrieved
  # @return Library database record

  def get_departments(id = nil)
    if id === nil
      Department.select('id, name')
    else
      Department.where('id = ?', id).select('id,name')
    end
  end

  def get_day(date = Date.today, resource = {})
    if self.special_hour_exists?(date, resource)
      self.get_special_hours(date, resource)
    else
      self.get_normal_hours(date, resource)
    end
  end

  # resources_for_list
  # ==================================================
  # Name : David J. Davis
  # Date : 3.23.2017
  #
  # Description: Generates an arry of DB Objects and returns that for iteration later.
  #
  # @return resources - id and name of a library or department, or both.
  # @todo needs work, right now the list isn't catecatenated togather, access with resource[0] and resource[1] if no type provided

  def resources_for_list
    resources = []
    if @params[:id].present? && @params[:type] == "library"
      resources << (get_libraries @params[:id])
    elsif @params[:id].present? && @params[:type] == "department"
      resources << (get_departments @params[:id])
    else
      resources << get_departments
      resources << get_libraries
    end
    resources
  end

end
