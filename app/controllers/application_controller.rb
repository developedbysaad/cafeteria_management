class ApplicationController < ActionController::Base
  before_action :setUser
  before_action :ensure_user_logged_in

  def setUser
    @current_user = current_user
  end

  def current_user
    @current_user if @current_user
    if session[:current_user_id]
      @current_user = User.find(session[:current_user_id])
    else
      nil
    end
  end

  def resetUser
    @current_user = session[:current_user_id] = nil
  end

  def ensure_user_logged_in
    unless current_user
      flash[:error] = "User should Sign in"
      redirect_to new_session_path
    end
  end

  def ensure_owner_logged_in
    unless current_user && current_user.role == "owner"
      flash[:error] = "Admin previlages cannot be accessed"
      redirect_to "/"
    end
  end

  def ensure_owner_or_clerk_logged_in
    unless current_user && current_user.role != "customer"
      flash[:error] = "Staff previlages cannot be accessed"
      redirect_to "/"
    end
  end
end
