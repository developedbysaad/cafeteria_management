class SessionsController < ApplicationController
  def new
    @signUpFlag = false
    render "home/index"
  end

  def create
    email = params[:email]
    user = User.find_by(email: email)
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to menus_path
      #render plain: "#{user.role} successful sign in"
    else
      flash[:error] = "Login attempt invalid.Please retry!"
      redirect_to new_session_path
    end
  end

  def destroy
    session[:current_order_id] = nil
    resetUser
    redirect_to "/"
  end
end
