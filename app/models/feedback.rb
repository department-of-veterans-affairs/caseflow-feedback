class Feedback < ActiveRecord::Base
  validates :subject, :username, :feedback, :contact_email, presence: true
  validates :contact_email, length: { maximum: 255 }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2
  }
end
