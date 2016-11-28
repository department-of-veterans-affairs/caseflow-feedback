class FeedbackController < ApplicationController
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

  def success
  end

  private

  def feedback_params
    params.require(:feedback)
          .permit(:feedback, :contact_email)
          .merge(application: session[:redirect], username: current_user.display_name)
  end
end
