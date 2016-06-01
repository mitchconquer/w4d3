class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :authenticity_token_field

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def authenticity_token_field
    %Q(<input name="authenticity_token" value="#{form_authenticity_token}" type="hidden">).html_safe
  end

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end
end
