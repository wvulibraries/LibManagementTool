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
    @params = params
  end

  def set_params(params)
    @params = params
  end

  def get_params
    @params
  end

  def get_hours
    hours = Array.new
    if valid_date_start && valid_date_end
      (Date.strptime(@params['date_start'], '%m-%d-%Y')..Date.strptime(@params['date_end'], '%m-%d-%Y')).each do |day|
        hours = get_day(day.wday, hours, day.strftime("%m-%d-%Y"))
      end
    elsif valid_date_start
     date_start = Date.strptime(@params['date_start'], '%m-%d-%Y')
     hours = get_day(date_start.wday, hours, date_start.strftime("%m-%d-%Y"))
    else
     current_date = Date.today
     hours = get_day(current_date.wday, hours, current_date.strftime("%m-%d-%Y"))
    end

    hours
  end

  private

  def hours_query(wday_to_show)
    if @params['id'].present?
      if valid_library || valid_department
        hours_list = NormalHour.where(resource_id: @params['id'], resource_type: @params['type'], day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
      else
        hours_list = NormalHour.where(resource_id: @params['id'], resource_type: 'library', day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
      end
    elsif valid_type
      hours_list = NormalHour.where(resource_type: @params['type'], day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    else
      hours_list = NormalHour.where(day_of_week: wday_to_show).where.not(open_time: nil, close_time: nil)
    end
  end

  def special_hour_exists(resource_id, resource_type, date_shown)
    special_list = SpecialHour.where(special_id: resource_id, special_type: resource_type)
    special_list.all.each do |special|
       if (special.start_date..special.end_date).cover?(Date.strptime(date_shown, '%m-%d-%Y'))
         if special.open_24
           return true, nil, nil, 'Open 24 Hours'
         else
           return true, special.hr_open_time, special.hr_close_time, "Temporary Special Hours"
         end
       end
    end
    return false, nil, nil, nil
  end

  def get_day(wday_to_show, hours, date_shown)
    hours_list = hours_query(wday_to_show)
    hours_list.all.each do |hour|
      special_exists, special_open_time, special_close_time, comment = special_hour_exists(hour.resource_id, hour.resource_type, date_shown)
      if special_exists
        hours.push({
          name: hour.get_resource,
          date: date_shown,
          open_time: special_open_time,
          close_time: special_close_time,
          comment: comment
        })
      else
        hours.push({
          name: hour.get_resource,
          date: date_shown,
          open_time: hour.hr_open_time,
          close_time: hour.hr_close_time,
          comment: nil
        })
      end
    end
    hours
  end

  # Validations

  def valid_date_start
    if @params['date_start'].present?
      # check for valid date
      Date.strptime(@params['date_start'], '%m-%d-%Y')
    else
      false
    end
  end

  def valid_date_end
    if @params['date_end'].present?
      # check for valid date
      Date.strptime(@params['date_end'], '%m-%d-%Y')
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
