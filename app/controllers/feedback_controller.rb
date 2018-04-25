# frozen_string_literal: true

class FeedbackController < ApplicationController
  before_action :verify_authentication
  before_action :verify_system_admin, except: [:new, :create]

  def admin
    @feedback = Feedback.paginate(page: params[:page], per_page: 5).order("created_at DESC")
    @count = Feedback.where("DATE(created_at) = ?", Time.zone.today).count
  end

  def new
    @feedback = Feedback.new
    session[:subject] = params[:subject] || "Caseflow"
    session[:redirect] = params[:redirect] || "caseflow.ds.va.gov"
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      slack = SlackService.new(current_domain: request.base_url,
                               subject: session[:subject],
                               github_url: @feedback.github_url)
      slack.send_new_feedback_notification
      render "success"
    else
      # Render the feedback form, but with a validation error.
      render "new"
    end
  end

  def search
    begin 
      term = params[:search].tr('*','%')
      term<<'%' unless term.end_with?('%')
      date_term = transform_date(term.dup) 
      github_term = term.dup.prepend('%')
      if !params[:search].blank?
        @feedback = Feedback.where('contact_email ILIKE ?', term)
        .or(Feedback.where('subject ILIKE ?', term))
        .or(Feedback.where('created_at::text ILIKE ?', date_term))
        .or(Feedback.where('github_url ILIKE ?', github_term))
        .or(Feedback.where('veteran_pii ILIKE ?', term)).paginate(page: params[:page], per_page: 5)
      else
        admin
      end
    rescue StandardError => e
      Rails.logger.error "FeedbackController failed search: #{e.message}"
      @feedback = Feedback.none.paginate(:page => params[:page]) 
    end
    respond_to do |format|
      format.json { render json: @feedback }
      format.html { render :admin } 
    end
  end

  private

  def feedback_params
    params.require(:feedback)
      .permit(:feedback, :contact_email, :veteran_pii)
      .merge(subject: session[:subject], username: current_user.display_name)
  end

  def transform_date(date)
    if date.include?('/')
      array = date.split(/\//)
      # Dashboard shows mm/dd/yy, but postgres saves as yyyy-mm-dd in created_at column
      if array.size == 3 
        array[2]<<'_' if array[2].length == 1 
        array.rotate!(-1)  
      end
      date = array.join('-')
    end
    date.prepend('%') unless date.start_with?('%')
    date<<'%' unless date.end_with?('%')
    date<<'__:__:__.%'
  end
end
