require 'date'

id = params[:id].present? ? params[:id] : nil
date_start = params[:date_start].present? ? params[:date_start] : nil
date_end = params[:date_end].present? ? params[:date_end] : nil
type = params[:type].present? ? params[:type] : nil
month = params[:month].present? ? params[:month] : nil
day = params[:day].present? ? params[:type] : nil
week = params[:week].present? ? params[:week] : nil
lib = params[:lib].present? ? params[:lib] : nil
dept = params[:dept].present? ? params[:dept] : nil

json.array! @normal_hours do |hours|
  # if query strings are nil then it lists all hours
  # this may change later
  display = false

  if !type.blank? && !id.blank?
    if id === hours.resource_id.to_s && type === hours.resource_type && !date_start.nil? && !date_end.nil?
      if !hours.open_time.blank? || !hours.close_time.blank?
        @dates = (hours.open_time.to_date..hours.close_time.to_date)
        display = @dates.include?(date_start.to_date) && @dates.include?(date_end.to_date)
      else
        display = true
      end
    end
  elsif !id.blank?
    if id === hours.id.to_s
      display = true
    end
  elsif !month.blank?
    if month === hours.month.to_s
      display = true
    end
  elsif !day.blank?
    if day === hours.day.to_s
      display = true
    end
  elsif !week.blank?
    if week === hours.day_of_week.to_s
      display = true
    end
  # check and see if lib is not blank
  elsif !lib.blank?
    if lib === hours.resource_id.to_s && "library" === hours.resource_type
      display = true
    end
  elsif !dept.blank?
    if dept === hours.resource_id.to_s && "department" === hours.resource_type
      display = true
    end
  else
    # if nothing has been pass display all
    display = true
  end

  if display && !hours.open_time.nil? && !hours.close_time.nil?
    json.id hours.id
    json.resource_type hours.resource_type
    json.resource_id hours.resource_id
    json.day_of_week hours.day_of_week
    json.open_time hours.open_time
    json.close_time hours.close_time
  end
end
