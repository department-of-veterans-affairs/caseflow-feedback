class Feedback < ActiveRecord::Base
  validates :application, :username, :feedback, presence: true
  enum status: [ :open, :in_progress, :closed ]
end
