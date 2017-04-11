# Admin Controller
# ==================================================
# AUTHORS : David J. Davis
# Description:
# Shared functions for all other admin scoped controllers.
class AdminController < ApplicationController

  # perform filter before action
  before_action CASClient::Frameworks::Rails::Filter
  before_action :get_user_permission, :check_permissions

  def index
    @username = session[:cas_user]
    @email = session[:cas_extra_attributes][:mail]
    @last_name = session[:cas_extra_attributes][:sn]
    if !session[:welcome]
      flash[:success] = "Welcome #{@username}!  You have been sucessfully logged in!"
      session[:welcome] = true;
    end
  end

  def logout
    session.delete('cas')
    redirect_to root_path, notice: 'Logged Out!'
  end

  private

  # check_permissions
  # ==================================================
  # Name : David J. Davis
  # Date : 2/10/2017
  #
  # Description:
  # uses the session that is provided buy the cas_user and authenticates that it is a valid cas session
  # Following that it checks that the user has been added and authorized to use the system.
  def check_permissions
    has_permission = User.where(username: session[:cas_user]).exists?
    if !has_permission
      redirect_to root_path, error: 'You do not have administrative permissions, please contact the system administrator if you feel that this has been reached in error.'
    elsif session[:cas_user].nil? && session[:cas_last_valid_ticket]
      redirect_to root_path, error: 'Something went wrong or a faulty login was detected.'
    else
      true
    end
  end

  # check_is_admin
  # ==================================================
  # Name : David J. Davis
  # Date : 2/10/2017
  #
  # Modified By : Tracy A. McCormick
  # Date : 3/9/2017
  # Description:
  # Gets the user by the session and checks returns the boolean value in the database
  def check_is_admin
    user = User.find_by(username: session[:cas_user])
    if user != nil
     user.admin
    else
     false
    end
  end

  # get_user_permission
  # ==================================================
  # Name : David J. Davis
  # Date : 2/10/2017
  #
  # Modified : Tracy A. McCormick
  # Date : 3/9/2017
  #
  # Description:
  # Sets the users libraries and department permissions in the session.
  # This will be used in other controllers in the admin section to be sure that
  # the user has the granualr permissions and is only used if the user is not an admin.
  def get_user_permission
    if session[:cas_user]
      user_permissions = UserPermission.find_by(username: session[:cas_user])
      # set @user_libs and @user_depts if they are not an admin
      if !check_is_admin && user_permissions != nil
        @user_libs = clean_array user_permissions.libraries
        @user_depts = clean_array user_permissions.departments
      end
    end
  end
end
