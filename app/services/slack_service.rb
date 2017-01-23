require "json"
require "httparty"

class SlackService
  include ActiveModel::Model

  attr_accessor :current_domain, :subject, :github_url

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end

  def http_service
    HTTParty
  end

  def send_new_feedback_notification
    return unless webhook_url

    body = { "text": message }.to_json
    params = { body: body, headers: { "Content-Type" => "application/json" } }
    http_service.post(ENV["SLACK_WEBHOOK_URL"], params)
    # TODO: log slack webhook errors in Sentry
  end

  def message
    admin_route = current_domain + "/admin"
    msg = "New feedback was submitted about #{subject}. View it in "
    msg += "<#{github_url}|Github> or " if github_url
    msg += "<#{admin_route}|Admin Dashboard>."
    msg
  end
end
