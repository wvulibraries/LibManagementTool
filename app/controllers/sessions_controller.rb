class SessionsController < ApplicationController
  def new
    # redirect_to '/auth/wvu'
  end

  def create
    # check the auth
    auth = request.env['omniauth.auth']

    # get a user (depending on information from WVU Cas this may change)
    user = User.where(:uid => auth['uid']);

    # store them in the session
    session[:user] = user.username
    redirect_to root_url, :notice => "Success!  You have been signed in."
  end

  def destroy
    # clear the session and redirect to root
    reset_session
    redirect_to root_url, :notice => "See you next time! You signed out."
  end

  def fail
    # failure throw the error on the root page
    redirect_to root_url :alert => "Authentication Error: #{params[:message].humanize}"
  end
end
