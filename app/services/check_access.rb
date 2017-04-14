# app/services/check_access.rb
# @author David J. Davis
# @author Tracy A. McCormick 
# gets departments libraries and preforms access level checks 
class CheckAccess
  # getters / setters in ruby
  attr_accessor :depts, :libs

  #check 
  # @param type [string] expecting department or library in lower case 
  # @param resource_id [int] expecting id of library or department 
  # @return boolean 
  def check(type, resource_id)
    @type = type.to_s.downcase
    @resource_id = resource_id
    check_type_access
  end

  private

  #check_type_access
  # checks to see if user departments or libraries match the ID
  # @return boolean
  def check_type_access
    if @type == 'library'
      @libs.include? @resource_id
    elsif @type == 'department'
      @depts.include? @resource_id
    else
      false
    end
  end
end
