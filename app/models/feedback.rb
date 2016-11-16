class Feedback < ActiveRecord::Base
	validates :application, :username, :feedback, presence: true
end
