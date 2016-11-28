class FeedbackController < ApplicationController

  before_action :verify_access, :except => [:new, :create]

  def admin
    @feedback = Feedback.all
  end

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

  private

  def verify_access
    #Passed string is irrelevant here, since can? methond always returns true for "System Admin" in user.rb
    verify_authorized_roles("System Admin")
  end

  def feedback_params
    params.require(:feedback).permit(:feedback).merge(application: session[:redirect])
          .merge(username: session[:username])
  end
end
