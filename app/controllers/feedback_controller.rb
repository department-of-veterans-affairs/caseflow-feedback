class FeedbackController < ApplicationController
  def new
    if Rails.env.development? || Rails.env.test?
      params[:app] = "caseflow"
      params[:username] = "ndjuric"
    end
    @feedback = Feedback.new
    session[:app] = params[:app]
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
    params.require(:feedback).permit(:feedback).merge(application: session[:app]).merge(username: session[:username])
  end
end
