class Feedback < ActiveRecord::Base
  include ApplicationHelper

  PII_PATTERN = /((?:^|[^0-9]|SS\ )[0-9]{3}[-\ ]?[0-9]{2}[-\ ]?[0-9]{4}(?![0-9])S?|(?:^|[^0-9]|C )
    [0-9]{1,2}\ ?[0-9]{3}\ ?[0-9]{3}(?![0-9])C?)/x
  EMAIL_PATTERN = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :subject, :username, :feedback, :contact_email, presence: true
  validates :feedback, length: { maximum: 2000 },
                       format: { without: PII_PATTERN }
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
