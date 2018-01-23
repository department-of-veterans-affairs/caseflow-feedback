# frozen_string_literal: true

require "erb"

class GithubIssueRenderer
  def initialize(email:, details:, username:)
    @username = username
    @email = email
    @details = details
    @template = File.read(Rails.root.join("lib/templates/github_issue.erb"))
  end

  def render
    ERB.new(@template).result(binding)
  end
end
