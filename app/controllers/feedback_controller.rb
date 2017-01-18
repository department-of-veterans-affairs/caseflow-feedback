class FeedbackController < ApplicationController
  before_action :verify_authentication
  before_action :verify_access, except: [:new, :create]

  def admin
    @feedback = Feedback.all
  end

  def new
    @feedback = Feedback.new
    session[:subject] = params[:subject] || "Caseflow"
    session[:redirect] = params[:redirect] || "caseflow.ds.va.gov"
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      SlackService.new.send_new_feedback_notification(request.base_url, session[:subject])
      render "success"
    else
      # Render the feedback form, but with a validation error.
      render "new"
    end
  end

  private

  def verify_access
    verify_authorized_roles("System Admin")
  end

  def feedback_params
    params.require(:feedback)
          .permit(:feedback, :contact_email)
          .merge(subject: session[:subject], username: current_user.display_name)
  end

end
