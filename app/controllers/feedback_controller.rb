class FeedbackController < ApplicationController
  before_action :verify_authentication
  before_action :verify_access, except: [:new, :create]

  def admin
    @feedback = Feedback.all
  end

  def new
    @feedback = Feedback.new
    session[:redirect] = params[:redirect] || "https://www.va.gov"
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      render "success"
    else
      # Render the feedback form, but with a validation error.
      render "new"
    end
  end

  private

  def verify_access
    # Passed string is irrelevant here, since can? method always returns true for "System Admin" in user.rb
    verify_authorized_roles("System Admin")
  end

  def feedback_params
    params.require(:feedback)
          .permit(:feedback, :contact_email)
          .merge(application: session[:redirect], username: current_user.display_name)
  end
end
