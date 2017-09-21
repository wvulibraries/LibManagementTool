# Admin Controller
# ==================================================
# AUTHORS : David J. Davis
# Description:
# Shared functions for all other admin scoped controllers.
class AdminController < ApplicationController
  # perform filter before action
  before_action CASClient::Frameworks::Rails::Filter
  before_action :valid_cas, :check_permissions

  def index
    @username = session[:cas_user]
    @email = session[:cas_extra_attributes][:mail]
    @last_name = session[:cas_extra_attributes][:sn]
    # return if session[:welcome]
    flash[:success] = "Welcome #{@username}! You have been sucessfully logged in!"
    session[:welcome] = true
  end

  def logout
    session.delete('cas')
    redirect_to root_path, notice: 'Logged Out!'
  end

  private
  
  # @author David J. Davis
  # @date 8/11/2017
  # @description 
  # validates if the user has a proper login or if session jacking occuring 
  def valid_cas
    error_str = "Faulty Login was detected, please try again or contact the system administrator."
    redirect_to root_path, error: error_str if session[:cas_user].nil? && session[:cas_last_valid_ticket]
  end 

  # @author David J. Davis
  # @date 8/11/2017
  # @description 
  # users the check access method for setting granular permissions 
  def check_permissions 
    @check_access = CheckAccess.new(session[:cas_user])
  end
end
