# app/services/check_access.rb
# @author David J. Davis
# @author Tracy A. McCormick 
# gets departments libraries and preforms access level checks 
class CheckAccess
  attr_accessor :depts
  attr_accessor :libs

  def check(type, resource_id)
    @type = type.to_s.downcase
    @resource_id = resource_id
    check_type_access
  end

  private

  def check_type_access
    if @type == 'library'
      @depts.include? @resource_id
    elsif @type == 'department'
      libs.include? @resource_id
    else
      false
    end
  end
end
