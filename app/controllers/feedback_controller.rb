class FeedbackController < ApplicationController
  def new
    if Rails.env.development? || Rails.env.test?
      params[:username] = params[:username] || "ANNE_MERICA"
    end
    @feedback = Feedback.new
    # If the query param is missing, for instance
    # if the user went straight to the feedback URL,
    # we'll collect feedback for "Caseflow" in general.
    session[:redirect] = params[:redirect] || "https://www.va.gov"
    # TODO(alex): harvest username from session rather than
    # query param.
    session[:username] = params[:username]
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      render "success"
    else
      render "new"
    end
  end

  def success
  end

  private

  def feedback_params
    params.require(:feedback)
      .permit(:feedback, :contact_email)
      .merge(application: session[:redirect], username: session[:username])
  end
end
