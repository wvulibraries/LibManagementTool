require 'date'

# HoursPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder
class HoursPresenter < BasePresenter
  # @todo
  #  convention says that this class is too long.  Ruby insists that classes are kept under
  #  a certain length. Rubo cop says that this class needs reduced.  Maybe RSS Presenter will ahve to be the next class made

  def initialize(params = {})
    set_params params
    @hours_array = []
  end


  # @todo
  # @see https://blog.metova.com/a-beginners-guide-to-ruby-getters-and-setters/
  #  this needs to go away in favor of
  #  attr_accessor :parameters
  #  attribute accessor creates getter setter and lets you use them as global variables,
  # however this will change the way that the presenter works.

  def set_params(params)
    @params = validated_params params
  end

  def get_params
    @params
  end

  # get_hours
  # @author Tracy McCormick
  # get hours verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  # @param - params (object) - params object given from the url and by rails
  # @return (array) - list of hours

  def get_hours
    if @params[:date_start] && @params[:date_end]
      (format_date(@params[:date_start])..format_date(@params[:date_end])).each do |day|
        get_day_list(day)
      end
    elsif @params[:date_start]
      get_day_list(format_date(@params[:date_start]))
    else
      get_day_list(Date.today)
    end
    @hours_array
  end

  # format_date
  # @author Tracy McCormick
  # format_date converts date string to a Ruby date object

  # @todo this is three lines, the line to do the conversion is 1 line.
  # not needed, just convert on the fly
  # if you feel you absolutely need a bunch of date conversions make a new
  # service class for dates
  def format_date(date)
    Date.strptime(date, DATE_FORMAT)
  end

  # array_push
  # @author Tracy McCormick
  #
  # Description: takes the passed hash and pushs the values to the hours_array
  def array_push(hash)
    @hours_array.push
    {
      name: hash[:name],
      date: hash[:date],
      open_time: hash[:open_time],
      close_time: hash[:close_time],
      comment: hash[:comment]
    }
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

  # get_day_list
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: gets available resources and checks each one calliing get_date
  # then it calls array_push to save the result.
  # @param - date (date): sets to today by default

  def get_day_list(date = Date.today)
    resources_for_list(@params[:id], @params[:type]).each do |resource|
      resource.each do |item|
        hash = { id: item.id, type: resource.name.downcase, date: date.strftime('%Y-%m-%d') }
        day = get_date(hash)
        array_push(name: get_resource_name(hash), date: date.strftime(DATE_FORMAT), open_time: day[:open_time], close_time: day[:close_time], comment: day[:comment])
      end
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

  # validated_params
  # ==================================================
  # Name : David J. Davis
  # Date :  3.22.2017
  # Modified : Tracy A. McCormick
  # Date : 4.7.2017
  #
  # Description: Removes all parameters that are not in the whitelist
  # of allowed parameters.
  # @param - params (object) - params object given from the url and by rails
  # @return (object) - cleaned object of params that are allowed removes - not allowed params

  def validated_params(params)
    allowed_keys = [:id, :type, :date_start, :date_end]
    params.select { |key,value| allowed_keys.include?(key) }
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
end
