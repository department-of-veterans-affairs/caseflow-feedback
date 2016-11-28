class Feedback < ActiveRecord::Base
  validates :application, :username, :feedback, presence: true
  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2
  }
end
