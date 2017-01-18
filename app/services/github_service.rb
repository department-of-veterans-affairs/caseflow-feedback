require "erb"

class GithubService

  # REPO = "department-of-veterans-affairs/appeals-support".freeze
  REPO = "aroltsch/checkers".freeze

  def create_issue(record)
    body = GithubIssueRenderer.new(username: record.username,
                                   email: record.contact_email,
                                   details: record.feedback).render
    Octokit.create_issue(REPO, record.feedback[0..100], body, labels: record.github_labels)[:url]
  end
end
