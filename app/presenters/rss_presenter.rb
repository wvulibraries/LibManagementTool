require 'time'

# RssPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the feeds_controller for use by the index.rss.builder
class RssPresenter < HoursPresenter
  attr_accessor :parameters
  attr_reader :rss_array

  def initialize(params = {})
    @parameters = validated_params params
    @rss_array = []
  end

  # create_day
  # @author Tracy A. McCormick
  # @date 04/12/2017
  # @param - params (object) - params object given from the url and by rails
  # get rss verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  def create_day
    type = @parameters[:type].present? ? @parameters[:type] : 'library'
    resources_for_list(@parameters[:id], type).each do |resource|
      resource.each do |item|
        push_item(item)
      end
    end
  end

  # create_time_stamp
  # @author Tracy A. McCormick
  # @date 04/12/2017
  # @param [String, #read] contents the contents to join with currently set date
  # @return [Integer] unix timestamp
  # Takes the passed string and joins concats it with a date string
  # that is set the presenter in global @date.
  # Returns a integer containing the unix time.
  def create_time_stamp(time_str)
    time_str = '12:00 AM' if time_str.nil? || time_str == ''
    date_time_str = @date + ' ' + time_str
    format_str = DATE_FORMAT + ' ' + '%H:%M %p'
    date_obj = Time.zone.strptime(date_time_str, format_str)
    date_obj.to_time.to_i
  end

  # make_timestamps
  # @author Tracy A. McCormick
  # @date 04/12/2017
  # @param - item (hash) - hash includes open_time, close_time
  # @return (hash) - open_time_stamp & close_time_stamp in unix time
  # takes a hash containing open_time and close_time. Then converts them
  # into unix time stamps and returns a hash containing open_time_stamp and
  # close_time_stamp
  def make_timestamps(hash = {})
    open_time_stamp = create_time_stamp(hash[:open_time])
    close_time_stamp = create_time_stamp(hash[:close_time])
    if open_time_stamp > 0 && close_time_stamp > 0
      close_time_stamp += 1.day if close_time_stamp < open_time_stamp
    end
    { open_time_stamp: open_time_stamp, close_time_stamp: close_time_stamp }
  end

  # push_item
  # @author Tracy A. McCormick
  # @date 04/12/2017
  # @param - item (object)
  # Takes the passed item and finds the hours if they exist.
  # Creates a new hash that is pushed to @rss_array.
  def push_item(item)
    item_hash =
      {
        id: item[:id],
        name: item[:name]
      }
    time_hash = find_hours(item)
    item_hash = item_hash.merge(time_hash).merge(make_timestamps(time_hash))
    @rss_array.push(item_hash)
  end

  # validated_params
  # @author David J. Davis
  # @author Tracy A. McCormick
  # @param params (hash) - params object given from the url and by rails
  # @return (hash) - cleaned object of params that are allowed removes - not allowed params
  # Removes all parameters that are not in the whitelist of allowed parameters.
  def validated_params(params)
    allowed_keys = [:id, :type, :date_start, :date_end]
    params.select { |key,_value| allowed_keys.include?(key) }
  end
end
