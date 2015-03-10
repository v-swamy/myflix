class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You are not logged in."
      redirect_to sign_in_path
    end
  end

  def access_denied
    flash[:danger] = "You are not permitted to do that."
    redirect_to root_path
  end

end
