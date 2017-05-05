# CalendarPresenter
# @author Tracy A. McCormick
# additional methods used for the calendar
class CalendarPresenter < HoursPresenter
  # resource_name
  # @author Tracy A. McCormick
  # @date 03/28/2017
  # @param - hash (hash)
  # returns either the Library name or combined department name & library name
  def resource_name(resource_hash = {})
    if resource_hash[:type] == 'department'
      resource = Department.find(resource_hash[:id])
      resource.name + ' - ' + resource.library.name
    else
      resource = Library.find(resource_hash[:id])
      resource.name
    end
  end

  # resource_name
  # @author Tracy A. McCormick
  # @date 04/26/2017
  # @param - hash (hash)
  # takes hash that contains id, type and date
  # returns open_time, close_time and a comment in a hash
  def find_hours_for_date(resource_hash = {})
    # Convert date from Y-m-d to d-m-Y
    @date = Date.strptime(hash[:date], API_DATE_FORMAT).strftime(DATE_FORMAT)
    resource = if resource_hash[:type] == 'department'
                 Department.find(resource_hash[:id])
               else
                 Library.find(resource_hash[:id])
               end
    find_hours(resource)
  end
end
