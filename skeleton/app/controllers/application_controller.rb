class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :authenticity_token_field

  def current_user
    # User.find_by(session_token: session[:session_token])
    return nil if session.nil?
    return nil unless session = SessionToken.find_by(token: self.session[:session_token])
    session.user
  end

  def authenticity_token_field
    %Q(<input name="authenticity_token" value="#{form_authenticity_token}" type="hidden">).html_safe
  end

  def login_user!(user, device)
    # Does current user/device combo exist in session_tokens?
    unless session_token = SessionToken.exists?(user, device)
      session_token = SessionToken.new(user_id: user.id, device: device, login_ip: "localhost")
      session_token.save
    end
    # Update user's session cookie
    session[:session_token] = session_token.token
  end

  def logout_user!(user, device)
    # Delete the curent session_token row for table
    return nil unless session = SessionToken.find_by(token: self.session[:session_token])
    session.destroy
    # Nil out the session[:session_token]
  end
end
