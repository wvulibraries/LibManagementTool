class AdminController < ApplicationController
  # perform filter before action
  before_action CASClient::Frameworks::Rails::Filter
  before_action :check_permissions

  def index
    @username = session[:cas_user]
    @email = session[:cas_extra_attributes][:mail]
    @last_name = session[:cas_extra_attributes][:sn]
    if !session[:welcome]
      flash[:success] = "Welcome #{@username}!  You have been sucessfully logged in!"
      session[:welcome] = true;
    end
  end

  private
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

  def check_is_admin
    user = User.find_by(username: session[:cas_user])
    user.admin = false
    user.admin
  end
end
