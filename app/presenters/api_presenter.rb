require 'date'

# ApiPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder
class ApiPresenter < HoursPresenter
  attr_accessor :parameters
  attr_reader :api_array

  def initialize(params = {})
    @parameters = validated_params params
    @api_array = []
  end

  # generate_list
  # @author Tracy A. McCormick
  # @param - params (object) - params object given from the url and by rails
  # checks params to see if date_start and date_end are set then loops
  # get hours verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  def generate_list
    if @parameters[:date_start] && @parameters[:date_end]
      add_date_range
    elsif @parameters[:date_start]
      create_day Date.strptime(@parameters[:date_start], DATE_FORMAT)
    else
      create_day Date.today
    end
  end

  # add_date_range
  # @author Tracy A. McCormick
  # @param - date (date): sets to today by default
  # loops over each day in the date range pushing each item to the
  # @api_array by calling create_day.
  def add_date_range
    date_start = Date.strptime(@parameters[:date_start], DATE_FORMAT)
    date_end = Date.strptime(@parameters[:date_end], DATE_FORMAT)
    dates = date_start..date_end
    dates.each do |day|
      create_day day
    end
  end

  # create_day
  # @author Tracy A. McCormick
  # @param - date (date): sets to today by default
  # finds resource and loop over each item pushing it to the array
  def create_day(date = Date.today)
    resources_for_list(@parameters[:id], @parameters[:type]).each do |resource|
      resource.each do |item|
        push_item(item, date)
      end
    end
  end

  # push_item
  # @author Tracy A. McCormick
  # @date 04/12/2017
  # @param - item (object)
  # Takes the passed item and finds the hours if they exist.
  # Creates a new hash that is pushed to @api_array.
  def push_item(item, date)
    item_hash =
      {
        name: item[:name],
        date: date.strftime(DATE_FORMAT)
      }
    @date = date.strftime(DATE_FORMAT)
    time_hash = find_hours(item)
    item_hash = item_hash.merge(time_hash)
    @api_array.push(item_hash)
  end

  # validated_params
  # @author David J. Davis
  # @author Tracy A. McCormick
  # @date : 04/07/2017
  # @param - params (object) - params object given from the url and by rails
  # @return (object) - cleaned object of params that are allowed removes - not allowed params
  # Removes all parameters that are not in the whitelist
  # of allowed parameters.
  def validated_params(params)
    allowed_keys = [:id, :type, :date_start, :date_end]
    params.select { |key,_value| allowed_keys.include?(key) }
  end
end
