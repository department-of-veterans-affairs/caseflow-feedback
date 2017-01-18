class Feedback < ActiveRecord::Base
  validates :subject, :username, :feedback, presence: true
  validates :contact_email, length: { maximum: 255 }, format: { with: /\A\S*@\S*\z/ }, allow_blank: true
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
    "Product Support Team, Source - Feedback, Current Sprint, #{APPLICATION_LABELS[subject]}"
  end

  private

  def create_github_issue
    github.create_issue(self)
  end

  def github
    (Rails.env.development? || Rails.env.demo?) ? GithubService.new : GithubService.new
  end
end
