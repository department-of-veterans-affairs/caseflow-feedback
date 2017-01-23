describe GithubIssueRenderer do
  it "should render the template" do
    renderer = GithubIssueRenderer.new(username: "FG666", email: "test@example.com", details: "wonderful")
    result = renderer.render
    expect(result).to match(/FG666/)
    expect(result).to match(/test@example.com/)
    expect(result).to match(/wonderful/)
  end
end
