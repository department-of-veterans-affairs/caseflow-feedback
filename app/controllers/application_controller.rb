class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :setup_fakes

  def setup_fakes
    return unless Rails.env.development? || Rails.env.test? || Rails.env.demo?
    Fakes::Initializer.development!
  end

  def current_user
    @current_user ||= User.from_session(session)
  end

  # TODO: (alex) uncomment once we use this to protect routes. rubocop doesn't likt it.
  # def verify_authentication
  #   return true if current_user && current_user.authenticated?

  #   session["return_to"] = request.original_url
  #   # TODO: (alex) set up the sessions controller so users are prompted
  #   # to go to the login page.
  #   redirect_to "/unauthorized"
  # end

  # def unauthorized
  #   render status: 403
  # end

  helper_method :current_user
end
