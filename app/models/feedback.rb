# frozen_string_literal: true

class Feedback < ApplicationRecord
  include ApplicationHelper

  EMAIL_PATTERN = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze

  validates :subject, :username, :feedback, :contact_email, :original_url, presence: true
  validates :feedback, length: { maximum: 2000 }
  validates :contact_email, length: { maximum: 255 }, format: { with: EMAIL_PATTERN }

  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  after_create :create_github_issue

  APPLICATION_LABELS = {
    "eFolder Express" => "eFolder",
    "Caseflow Dispatch" => "Dispatch",
    "Caseflow Reader" => "Reader",
    "Caseflow Hearing Prep" => "Hearing Prep",
    "Caseflow Intake" => "Intake",
    "Caseflow Queue" => "Queue",
    "Caseflow" => "Caseflow",
    "Caseflow Certification" => "Certification"
  }.freeze

  def github_labels
    labels = "Source - Feedback, Current Sprint"
    labels += ", " + APPLICATION_LABELS[subject] if APPLICATION_LABELS[subject]
    labels
  end

  def title
    "Feedback from " + username
  end

  def render_issue_template
    GithubIssueRenderer.new(username: username,
                            email: contact_email,
                            details: feedback,
                            original_url: original_url).render
  end

  def issue_number
    github_url.present? ? github_url.split("/")[6] : ""
  end

  private

  def create_github_issue
    url = github.create_issue(title: title,
                              body: render_issue_template,
                              labels: github_labels)
    update(github_url: url)
  end

  def github
    use_fakes? ? Fakes::GithubService.new : GithubService.new
  end
end
