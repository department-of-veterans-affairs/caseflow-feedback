require "json"
require "httparty"

class SlackService
  def send_new_feedback_notification(current_domain, subject)
    # return unless ENV["SLACK_WEBHOOK_URL"]

    # TODO(alex): linking to demo for now. this should be enabled only in prod
    # after we finish testing it. we'll use the prod url then.
    admin_url = "https://dsva-appeals-feedback-demo-1748368704.us-gov-west-1.elb.amazonaws.com/admin"
    message = "New feedback was submitted about #{subject}. <#{admin_url}|Click here> to view it."
    body = {"text": message}.to_json

    webhook_url = ENV["SLACK_WEBHOOK_URL"]

    result = HTTParty.post(webhook_url, {:body => body, :headers => { 'Content-Type' => 'application/json' } } )
  end
end
