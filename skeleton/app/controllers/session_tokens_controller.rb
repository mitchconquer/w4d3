class SessionTokensController < ApplicationController

  def create
    user = User.find_by_credentials(login_params[:user_name], login_params[:password])
    device = request.env["HTTP_USER_AGENT"]
    # device = request.env
    # fail
    if user.nil?
      render :new
    else
      login_user!(user, device)
      redirect_to cats_url
    end
  end

  def destroy
    logout_user!(user, device)
    redirect_to cats_url
  end

  def new
    @session_token = SessionToken.new
  end

  private
  def login_params
    params.require(:session).permit(:user_name, :password)
  end

  def session_token_params
    params.require(:session_token).permit(:user_id, :login_ip, :device)
  end

end
