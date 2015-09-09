class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      redirect_to dashboard_path
      # flash[:message] = "Welcome, #{@user.nickname}"
    else
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    # flash[:message] = "You have logged out"
    redirect_to root_path
  end
end
