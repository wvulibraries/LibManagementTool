# app/presenters/hours_presenter.rb

# Hours Presenter
# ==================================================
# AUTHORS : Tracy A. McCormick
# Description:
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder

require 'date'

class HoursPresenter

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
    @date_start = params[:date_start].present? ? Date.strptime(params[:date_start], @date_format) : nil
    @date_end = params[:date_end].present? ? Date.strptime(params[:date_end], @date_format) : nil

    @hours = Array.new
  end

  def set_params(params)
    @params = params
  end

  def get_params
    @params
  end

  def get_hours
    if @date_start && @date_end
      get_hours_list
    elsif @date_start
      get_day(@date_start.strftime(@date_format))
    else
      get_day(Date.today.strftime(@date_format))
    end
    @hours
  end

  private

  def format_date(date)
   Date.strptime(date, @date_format)
  end

  def hours_query(wday_to_show)
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

  def get_special_hour(resource_id, resource_type, date_shown)
    special_list = SpecialHour.where(special_id: resource_id, special_type: resource_type)
    special_list.all.each do |special|
       if (special.start_date..special.end_date).cover?(format_date(date_shown))
         if special.open_24
           @hours.push({
             name: special.get_resource,
             date: date_shown,
             open_time: nil,
             close_time: nil,
             comment: "Open 24 Hours"
           })
           true
         else
           @hours.push({
             name: special.get_resource,
             date: date_shown,
             open_time: special.hr_open_time,
             close_time: special.hr_close_time,
             comment: "Temporary Special Hours"
           })
           true
         end
       end
    end
    false
  end

  def get_day(date_shown)
    hours_list = hours_query(Date.strptime(date_shown, @date_format).wday)
    hours_list.all.each do |hour|
      if !get_special_hour(hour.resource_id, hour.resource_type, date_shown)
        @hours.push({
          name: hour.get_resource,
          date: date_shown,
          open_time: hour.hr_open_time,
          close_time: hour.hr_close_time,
          comment: nil
        })
      end
    end
  end

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

  def valid_month
    if @params['month'].present?
      (1..12).include?(@params['month'].to_i)
    else
      false
    end
  end

  def valid_week
    if @params['week'].present?
      (1..52).include?(@params['week'].to_i)
    else
      false
    end
  end

end
