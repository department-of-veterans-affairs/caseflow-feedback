class Feedback < ActiveRecord::Base
  validates :subject, :username, :feedback, presence: true
  validates :contact_email, length: { maximum: 255 }, format: { with: /\A\S*@\S*\z/ }, allow_blank: true
  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2
  }
end
