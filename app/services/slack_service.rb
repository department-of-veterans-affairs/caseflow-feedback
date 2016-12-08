require "json"
require "httparty"

class SlackService
  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end

  def http_service
    HTTParty
  end

  def send_new_feedback_notification(current_domain, subject)
    return unless webhook_url

    message = "New feedback was submitted about #{subject}. <#{current_domain}|Click here> to view it."
    body = { "text": message }.to_json
    params = { body: body, headers: { "Content-Type" => "application/json" } }
    http_service.post(ENV["SLACK_WEBHOOK_URL"], params)
    # TODO: log slack webhook errors in Sentry
  end
end
