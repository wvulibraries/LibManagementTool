require 'date'
require 'time'

# RssPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the feeds_controller for use by the index.rss.builder
class RssPresenter < BasePresenter
  attr_accessor :id, :type, :date
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
    @id_set = @id.nil?
    @type = 'library' if @type.nil?

    resources_for_list(@id, @type).each do |resource|
      resource.each do |item|
        set_values(item)
        find_special_hours(item) if special_hours_exists?(item) || find_normal_hours(item)
        set_timestamps
        rss_array_push
      end
    end
  end

  def set_values(item)
    # set global inital values
    @open_time = nil
    @close_time = nil
    @comment = 'Closed'
    @name = item[:name]
    @id = item[:id] if @id_set
    @open_time_stamp = ''
    @close_time_stamp = ''
  end

  def find_normal_hours(resource)
    resource.normal_hours.each do |hour|
      next unless hour.day_of_week == Date.strptime(@date, DATE_FORMAT).wday
      @open_time = hour.hr_open_time unless hour.open_time.nil?
      @close_time = hour.hr_close_time unless hour.close_time.nil?
      unless hour.open_time.nil? && hour.close_time.nil?
        @comment = @open_time + ' - ' + @close_time
      end
    end
  end

  def special_hours_exists?(resource)
    return unless resource.special_hours.count > 0
    resource.special_hours.each do |hour|
      next unless Date.strptime(@date, DATE_FORMAT).between?(hour.start_date.to_date, hour.end_date.to_date)
      true
    end
    false
  end

  def find_special_hours(resource)
    resource.special_hours.each do |hour|
      next unless Date.strptime(@date, DATE_FORMAT).between?(hour.start_date.to_date, hour.end_date.to_date)
      @open_time = hour.hr_open_time unless hour.open_time.nil?
      @close_time = hour.hr_close_time unless hour.close_time.nil?
      if hour.open_24
        @comment = 'Open 24 Hours'
      elsif !hour.open_time.nil? && !hour.close_time.nil?
        @comment = @open_time + ' - ' + @close_time
      end
    end
  end

  def create_time_stamp(date, time)
    date_time_str = date + ' ' + time
    date_obj = Time.zone.strptime(date_time_str, DATE_FORMAT + '%H:%M %p')
    date_obj.to_time.to_i
  end

  def set_timestamps
    @open_time_stamp = create_time_stamp(@date, @open_time) unless @open_time.nil?
    @close_time_stamp = create_time_stamp(@date, @close_time) unless @close_time.nil?
    @close_time_stamp += 1.day if @close_time_stamp < @open_time_stamp
  end

  # rss_array_push
  # ==================================================
  # Name : Tracy McCormick
  # Date : 04/12/2017
  #
  # Description: takes the passed hash and pushs the values to the hours_array
  # for use with the rss feed
  def rss_array_push
    @rss_array.push(
      id: @id,
      name: @name,
      type: @type,
      date: @date,
      open_time: @open_time,
      close_time: @close_time,
      open_time_stamp: @open_time_stamp,
      close_time_stamp: @close_time_stamp,
      comment: @comment
    )
  end
end
