# app/services/check_access.rb
class CheckAccess

  def self.initialize (user_depts, user_libs)
    @user_depts = user_depts
    @user_libs = user_libs
  end

  def self.set_depts(depts)
    @user_depts = depts
  end

  def self.get_depts
    @user_depts
  end

  def self.set_libs(libs)
    @user_libs = libs
  end

  def self.get_libs
    @user_libs
  end

  def self.check(type, resource_id)
    @type = type
    @resource_id = resource_id
    check_type_access
  end

  private
    def self.check_type_access
      if (@type === 'library')
        user_libraries
      elsif (@type === 'department')
        user_departments
      else
        false
      end
    end

    def self.user_departments
      @user_depts.include? @resource_id
    end

    def self.user_libraries
      @user_libs.include? @resource_id
    end
end
