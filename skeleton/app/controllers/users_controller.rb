class UsersController < ApplicationController
  before_action :redirect_to_index, only: [:create, :new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def redirect_to_index
    redirect_to cats_url if current_user
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
