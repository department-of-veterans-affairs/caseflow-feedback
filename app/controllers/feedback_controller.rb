class FeedbackController < ApplicationController
  def new
    if Rails.env.development? || Rails.env.test?
      params[:username] = params[:username] || "ANNE_MERICA"
    end
    @feedback = Feedback.new
    # If the query param is missing, for instance
    # if the user went straight to the feedback URL,
    # we'll collect feedback for "Caseflow" in general.
    session[:app_url] = params[:app_url] || "https://caseflow.ds.va.gov/certifications/123C/new"
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
    params.require(:feedback).permit(:feedback).merge(application: session[:app_url]).merge(username: session[:username])
  end
end
