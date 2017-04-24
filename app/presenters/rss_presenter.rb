require 'date'
require 'time'

# RssPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the feeds_controller for use by the index.rss.builder
class RssPresenter < BasePresenter
  attr_accessor :id, :type, :date, :p
  attr_reader :rss_array

  def initialize
    @rss_array = []
  end

  # generate_list
  # ==================================================
  # Name : Tracy McCormick
  # Date : 04/12/2017
  #
  # Description: get rss verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  #
  # @param - params (object) - params object given from the url and by rails
  # @return (array) - list of hours

  def generate_list
    type = @p[:type].present? ? @p[:type] : 'library'

    resources_for_list(@p[:id], type).each do |resource|
      resource.each do |item|
        push_item(item)
      end
    end
  end

  def find_normal_hours(resource)
    # Set Default values
    open_time = nil
    close_time = nil
    comment = 'Closed'

    resource.normal_hours.each do |hour|
      next unless hour.day_of_week == Date.strptime(@date, DATE_FORMAT).wday
      open_time = hour.hr_open_time unless hour.open_time.nil?
      close_time = hour.hr_close_time unless hour.close_time.nil?
      if !hour.open_time.nil? && !hour.close_time.nil?
        comment = open_time + ' - ' + close_time
      end
    end
    { open_time: open_time, close_time: close_time, comment: comment }
  end

  def special_hours_exists?(resource)
    return false unless resource.special_hours.count > 0
    resource.special_hours.each do |hour|
      next unless Date.strptime(@date, DATE_FORMAT).between?(hour.start_date.to_date, hour.end_date.to_date)
      true
    end
    false
  end

  def find_special_hours(resource)
    resource.special_hours.each do |hour|
      next unless Date.strptime(@date, DATE_FORMAT).between?(hour.start_date.to_date, hour.end_date.to_date)
      open_time = hour.hr_open_time unless hour.open_time.nil?
      close_time = hour.hr_close_time unless hour.close_time.nil?
      if hour.open_24
        comment = 'Open 24 Hours'
      elsif hour.open_time.nil? && hour.close_time.nil?
        comment = open_time + ' - ' + close_time
      end
      { open_time: open_time, close_time: close_time, comment: comment }
    end
    false
  end

  def create_time_stamp(time_str)
    return 0 unless time_str
    date_time_str = @date + ' ' + time_str
    format_str = DATE_FORMAT + ' ' + '%H:%M %p'
    date_obj = Time.zone.strptime(date_time_str, format_str)
    date_obj.to_time.to_i
  end

  def make_timestamps(hash = {})
    open_time_stamp = create_time_stamp(hash[:open_time])
    close_time_stamp = create_time_stamp(hash[:close_time])
    if open_time_stamp > 0 || close_time_stamp > 0
      close_time_stamp += 1.day if close_time_stamp < open_time_stamp
    end
    { open_time_stamp: open_time_stamp, close_time_stamp: close_time_stamp }
  end

  def find_hours(item)
    return find_normal_hours(item) unless special_hours_exists?(item)
    find_special_hours(item)
  end

  # rss_array_push
  # ==================================================
  # Name : Tracy McCormick
  # Date : 04/12/2017
  #
  # Description: takes the passed hash and pushs the values to the hours_array
  # for use with the rss feed
  def push_item(item)
    return unless item

    time_hash = find_hours(item)
    timestamps = make_timestamps(time_hash)
    puts timestamps.inspect

    @rss_array.push(
      id: item[:id],
      name: item[:name],
      type: item[:type],
      date: @date,
      open_time: time_hash[:open_time],
      close_time: time_hash[:close_time],
      open_time_stamp: timestamps[:open_time],
      close_time_stamp: timestamps[:close_time],
      comment: time_hash[:comment]
    )
  end
end
