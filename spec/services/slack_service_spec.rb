describe SlackService do
  before do
    ENV["SLACK_WEBHOOK_URL"] = "test.slack.url"
  end

  it "posts to http" do
    slack_service = SlackService.new(current_domain: "www.domain.com",
                                     subject: "feedback_subject")
    slack_service.http_service.stub(:post).and_return("response")
    response = slack_service.send_new_feedback_notification
    expect(response).to eq("response")
  end

  it "constructs the message" do
    slack = SlackService.new(current_domain: "www.domain.com",
                             subject: "feedback_subject")
    expect(slack.message).to_not match(/Github/)

    slack = SlackService.new(current_domain: "www.domain.com",
                             subject: "feedback_subject",
                             github_url: "www.example.com")
    expect(slack.message).to match(/Github/)
  end

  after do
    ENV["SLACK_WEBHOOK_URL"] = nil
  end
end
