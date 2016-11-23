class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :setup_fakes

  def setup_fakes
    Fakes::Initializer.development! if (Rails.env.development? || Rails.env.test?)
  end

  def current_user
    @current_user ||= User.from_session(session)
  end

  def verify_authentication
    return true if current_user && current_user.authenticated?

    session["return_to"] = request.original_url
    # TODO: (alex) set up the sessions controller so users are prompted
    # to go to the login page.
    redirect_to "/unauthorized"
  end

  def unauthorized
    render status: 403
  end

  helper_method :current_user
end
