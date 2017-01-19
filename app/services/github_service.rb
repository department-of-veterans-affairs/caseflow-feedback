# frozen_string_literal: true
require "erb"

class GithubService
  REPO = "department-of-veterans-affairs/appeals-support".freeze

  def create_issue(title:, body:, labels:)
    issue = Octokit.create_issue(REPO, title, body, labels: labels)
    issue[:html_url] if issue
  end
end
