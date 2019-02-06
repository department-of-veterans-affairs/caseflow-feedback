# frozen_string_literal: true

describe GithubIssueRenderer do
  it "should render the template" do
    renderer = GithubIssueRenderer.new(username: "FG666", email: "test@example.com", details: "wonderful",
                                       original_url: "caseflow.ds.va.gov/application/123456789")
    result = renderer.render
    expect(result).to match(/FG666/)
    expect(result).to match(/test@example.com/)
    expect(result).to_not match(/wonderful/)
  end
end
