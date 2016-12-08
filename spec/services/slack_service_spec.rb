describe SlackService do
  before do
    ENV["SLACK_WEBHOOK_URL"] = "test.slack.url"
  end

  it "posts to http" do
    slack_service = SlackService.new
    slack_service.http_service.stub(:post).and_return("response")
    response = slack_service.send_new_feedback_notification("www.domain.com", "feedback_subject")
    expect(response).to eq("response")
  end

  after do
    ENV["SLACK_WEBHOOK_URL"] = nil
  end
end
