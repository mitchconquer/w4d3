class SessionsController < ApplicationController
  before_action :redirect_to_index, only: [:new, :create]

  def new

  end

  def create
    user = User.find_by_credentials(login_params[:user_name], login_params[:password])
    if user.nil?
      render :new
    else
      login_user!(user)
      redirect_to cats_url
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to cats_url
  end

  def redirect_to_index
    redirect_to cats_url if current_user
  end

  private
  def login_params
    params.require(:session).permit(:user_name, :password)
  end
end
