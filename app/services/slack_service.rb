require "json"
require "httparty"

class SlackService
  def send_new_feedback_notification(current_domain, subject)
    return unless ENV["SLACK_WEBHOOK_URL"]

    message = "New feedback was submitted about #{subject}. <#{current_domain}|Click here> to view it."
    body = {"text": message}.to_json
    params = {:body => body, :headers => { "Content-Type" => "application/json" } }
    response = HTTParty.post(ENV["SLACK_WEBHOOK_URL"], params)
    # TODO log slack feedback errors in Sentry
  end
end
