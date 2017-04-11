# app/services/check_access.rb
class CheckAccess

  def initialize (user_depts, user_libs)
    # puts user_depts.inspect
    # puts user_libs.inspect
    self.set_depts(user_depts)
    self.set_libs(user_libs)
  end

  def set_depts(depts)
    @user_depts = depts
  end

  def get_depts
    @user_depts
  end

  def set_libs(libs)
    @user_libs = libs
  end

  def get_libs
    @user_libs
  end

  def check(type, resource_id)
    @type = type.to_s.downcase
    @resource_id = resource_id
    check_type_access
  end

  private
    def check_type_access
      if (@type === 'library')
        user_libraries
      elsif (@type === 'department')
        user_departments
      else
        false
      end
    end

    def user_departments
      @user_depts.include? @resource_id
    end

    def user_libraries
      @user_libs.include? @resource_id
    end
end
