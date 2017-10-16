# app/services/check_access.rb 
# @author David J. Davis
# @author Tracy A. McCormick
# used for custom permission system

class CheckAccess
  include ActiveModel::Validations

  # attributes
  attr_accessor :user

  # validations
  validates_presence_of :user
  validate :user_permission

  # init 
  def initialize(user)
    @user = user
    @logged_user = User.find_by(username: @user)
    @user_permission = UserPermission.find_by(username: @user)
  end

  # admin?
  # @author David J. Davis 
  # @description tells if the user is an admin in the system 
  # @return boolean [true/false]
  def admin?
    @logged_user.admin?
  end

  # permission?
  # @author David J. Davis
  # @description:
  # checks to see if user exists in the database if so they have permission
  # @return boolean [true/false]
  def permission?
    User.where(username: @user).exists?
  end

  def library_permission? resource_id
    if admin? || !libraries.nil? && (libraries.include? resource_id)
      true
    else 
      false
    end 
  end 

  def department_permission? resource_id
    if admin? || !departments.nil? && (departments.include? resource_id)
      true
    else 
      false
    end 
  end 

  def granular_permission? type, resource_id
    if type == 'library'
      library_permission? resource_id
    elsif type == 'department'
      department_permission? resource_id
    else
      false
    end
  end

  def libraries
    @user_permission.libraries.to_a
  end

  def departments
    @user_permission.departments.to_a
  end

  private
  def user_permission
    errors.add(:user, 'you do not have permission') unless permission?
  end
end