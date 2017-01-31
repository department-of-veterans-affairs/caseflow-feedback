class Feedback < ActiveRecord::Base
  include ApplicationHelper

  validates :subject, :username, :feedback, :contact_email, presence: true
  validates :feedback, length: { maximum: 2000 }
  validates :contact_email, length: { maximum: 255 }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2
  }

  after_create :create_github_issue

  APPLICATION_LABELS = {
    "eFolder Express" => "eFolder",
    "Caseflow Dispatch" => "Dispatch",
    "Caseflow" => "Certification",
    "Caseflow Certification" => "Certification"
  }.freeze

  def github_labels
    labels = "Product Support Team, Source - Feedback, Current Sprint"
    labels += ", " + APPLICATION_LABELS[subject] if APPLICATION_LABELS[subject]
    labels
  end

  def render_issue_template
    GithubIssueRenderer.new(username: username,
                            email: contact_email,
                            details: feedback).render
  end

  def issue_number
    github_url.present? ? github_url.split("/")[6] : ""
  end

  private

  def create_github_issue
    url = github.create_issue(title: feedback[0..100],
                              body: render_issue_template,
                              labels: github_labels)
    update_attributes(github_url: url)
  end

  def github
    use_fakes? ? Fakes::GithubService.new : GithubService.new
  end
end
