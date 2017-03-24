# app/presenters/hours_presenter.rb

# Hours Presenter
# ==================================================
# AUTHORS : Tracy A. McCormick
# Description:
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder

require 'date'

class HoursPresenter

  attr_accessor  :id, :type, :date_start, :date_end

  # initializer
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description:
  # initialize sets up global variables used by the presenter
  # most of these are based on the params that are passed
  # or setting default values.
  def initialize(params = {})
    # set constants
    @date_format = '%m-%d-%Y'

    @params = params

    # check and set url values
    # @month = params[:month].present? ? params[:month] : nil
    # @day = params[:day].present? ? params[:type] : nil
    # @week = params[:week].present? ? params[:week] : nil
    # @lib = params[:lib].present? ? params[:lib] : nil
    # @dept = params[:dept].present? ? params[:dept] : nil

    @id = params[:id].present? ? params[:id] : nil
    @type = params[:type].present? ? params[:type] : nil

    ## set start and end date if present in params
    @date_start = params[:date_start].present? ? Date.strptime(params[:date_start], @date_format) : Date.today
    @date_end = params[:date_end].present? ? Date.strptime(params[:date_end], @date_format) : nil

    @hours_array = Array.new
  end

  # set_params
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: basic setter for params
  def set_params(params)
    @params = params
  end

  # get_params
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: basic getter for params
  def get_params
    @params
  end

  # get_hours
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: get hours verifys the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  def get_hours
    #check and see if date_start and date end are set_params
    if @date_start && @date_end
      # call get_hours_list to create the hours_array list
      get_hours_list
    elsif @date_start
      # if only date_start is present call get_day
      # to populate the hours_array with items for that day
      get_day(@date_start.strftime(@date_format))
    end
    # return array back to the calling jbuilder
    @hours_array
  end

  private

  def format_date(date)
   Date.strptime(date, @date_format)
  end


  # normal_hours_query
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: hours verifys the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  def normal_hours_query(wday_to_show)
    # if valid_month
    #
    # elsif valid_day
    #
    # elsif valid_week
    #
    # elsif valid_lib
    #   hours_list = NormalHour.where(resource_id: @lib, resource_type: 'library').where.not(open_time: nil, close_time: nil)
    # elsif valid_dept
    #   hours_list = NormalHour.where(resource_id: @dept, resource_type: 'department').where.not(open_time: nil, close_time: nil)

    if valid_library || valid_department
      hours_list = NormalHour.where(resource_id: @id, resource_type: @type, day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    elsif valid_id && @type.nil?
      hours_list = NormalHour.where(resource_id: @id, resource_type: 'library', day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    elsif valid_type && @id.nil?
      hours_list = NormalHour.where(resource_type: @type, day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    else
      hours_list = NormalHour.where(day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    end
  end


  # get_special_hour
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: takes resource_id, resource_type and date
  # check if a special_hour exists. If exists check if resource is open_24
  # push a open 24 hours item for the resource to the hours_array
  # else pushs the special_hour to the hours_array.
  def get_special_hour(resource_id, resource_type, date_shown)
    found = false
    special_list = SpecialHour.where(special_id: resource_id, special_type: resource_type)
    special_list.all.each do |special|
       if (special.start_date..special.end_date).cover?(format_date(date_shown))
         found = true
         if special.open_24
           @hours_array.push({
             name: special.get_resource,
             date: date_shown,
             open_time: nil,
             close_time: nil,
             comment: "Open 24 Hours"
           })
         else
           @hours_array.push({
             name: special.get_resource,
             date: date_shown,
             open_time: special.hr_open_time,
             close_time: special.hr_close_time,
             comment: "Temporary Special Hours"
           })
         end
       end
    end
    found
  end

  # get_day
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: takes the date string given and calls normal_hours_query
  # to get the list of available items. It checks each item by first checking to see if
  # a special_hour exists if not then it pushs the normal_hour to the hours_array.
  def get_day(date_shown)
    hours_list = normal_hours_query(format_date(date_shown).wday)
    hours_list.all.each do |hour|
      if !get_special_hour(hour.resource_id, hour.resource_type, date_shown)
        @hours_array.push({
          name: hour.get_resource,
          date: date_shown,
          open_time: hour.hr_open_time,
          close_time: hour.hr_close_time,
          comment: nil
        })
      end
    end
  end

  # get_hours_list
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: loops from @date_start to @date_end calling get_day
  # for each day.
  def get_hours_list
    (@date_start..@date_end).each do |day|
      get_day(day.strftime(@date_format))
    end
  end

  # Validations

  def valid_date_start
    if @params['date_start'].present?
      # check for valid date
      format_date(@params['date_start'])
    else
      false
    end
  end

  def valid_date_end
    if @params['date_end'].present?
      # check for valid date
      format_date(@params['date_end'])
    else
      false
    end
  end

  def valid_library
    if @params['type'].present? && @params['id'].present? && @params['type'] === "library"
      Library.where("resource_id = ? ", @params['id']).limit(1)
    else
      false
    end
  end

  def valid_department
    if @params['type'].present? && @params['id'].present? && @params['type'] === "department"
      Department.where("resource_id = ? ", @params['id']).limit(1)
    else
      false
    end
  end

  def valid_id
    if @params['id'].present?
      Library.where("resource_id = ? ", @params['id']).limit(1)
    else
      false
    end
  end

  def valid_type
    @params['type'].present? && (@params['type'] === "library" || @params['type'] === "department")
  end

  # def valid_month
  #   if @params['month'].present?
  #     (1..12).include?(@params['month'].to_i)
  #   else
  #     false
  #   end
  # end
  #
  # def valid_week
  #   if @params['week'].present?
  #     (1..52).include?(@params['week'].to_i)
  #   else
  #     false
  #   end
  # end

end
