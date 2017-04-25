require 'date'

# HoursPresenter
# @author David J. Davis
# @author Tracy A. McCormick
# Compiles the hours list using data from NormalHour and SpecialHour
# used by the api_controller for use by the gethours.json.jbuilder
class ApiPresenter < HoursPresenter
  attr_accessor :p
  attr_reader :api_array

  # @todo
  #  convention says that this class is too long.  Ruby insists that classes are
  #  kept under a certain length. Rubo cop says that this class needs reduced.
  #  Maybe RSS Presenter will have to be the next class made

  def initialize(params = {})
    @p = validated_params params
    @api_array = []
  end

  # get_hours
  # @author Tracy McCormick
  # get hours verify's the presence of date_start and date_end
  # call get_hours_list if both are available otherwise it calls get_day.
  # @param - params (object) - params object given from the url and by rails
  # @return (array) - list of hours

  def generate_list
    if @p[:date_start] && @p[:date_end]
      (Date.strptime(@p[:date_start], DATE_FORMAT)..Date.strptime(@p[:date_end], DATE_FORMAT)).each do |day|
        day_list(day)
      end
    elsif @p[:date_start]
      day_list(Date.strptime(@p[:date_start], DATE_FORMAT))
    else
      day_list(Date.today)
    end
  end

  # day_list
  # ==================================================
  # Name : Tracy McCormick
  # Date : 03/24/2017
  #
  # Description: gets available resources and checks each one calliing get_date
  # then it calls array_push to save the result.
  # @param - date (date): sets to today by default

  def day_list(date = Date.today)
    resources_for_list(@p[:id], @p[:type]).each do |resource|
      resource.each do |item|
        push_item(item, resource.name.downcase, date)
      end
    end
  end

  # push_item
  # @author Tracy McCormick
  #
  # Description: takes the passed hash and pushs the values to the hours_array

  def push_item(item, type, date)
    item_hash =
      {
        name: item[:name],
        date: date.strftime(DATE_FORMAT)
      }
    time_hash = get_date(id: item[:id], type: type, date: date.strftime(API_DATE_FORMAT))
    item_hash = item_hash.merge(time_hash)
    @api_array.push(item_hash)
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
end
