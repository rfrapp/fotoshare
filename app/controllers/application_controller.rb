class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  include UsersHelper 
  before_action :set_host 

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location 
      flash[:danger] = "Please log in to view this page."
      redirect_to login_url
    end
  end

  def set_host 
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end 
end
