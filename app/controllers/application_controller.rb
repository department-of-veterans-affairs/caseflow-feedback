class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :setup_fakes

  def setup_fakes
    Fakes::Initializer.development! if Rails.env.development?
  end

  def current_user
    @current_user ||= User.from_session(session)
  end

  def verify_authentication
    return true if current_user && current_user.authenticated?

    session["return_to"] = request.original_url
    redirect_to login_path
  end

  helper_method :current_user
end
