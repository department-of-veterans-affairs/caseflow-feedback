require 'net/http'
require 'uri'
require 'json'

class SlackService
  def send_new_feedback_notification(current_domain, subject)
    # return unless ENV["CASEFLOW_FEEDBACK_URL"] && ENV["SLACK_NOTIFICATION_URL"]

    # TODO(alex): linking to demo for now. this should be enabled only in prod
    # after we finish testing it. we'll use the prod url then.
    admin_url = "https://dsva-appeals-feedback-demo-1748368704.us-gov-west-1.elb.amazonaws.com/admin"
    message = "New feedback was submitted about #{subject}. <#{admin_url}|Click here> to view it."
    header = {"Content-Type": "text/json"}

    webhook_url = "***REMOVED***"
    uri = URI.parse(webhook_url)

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = message.to_json

    # Send the request
    response = http.request(request)
  end
end
