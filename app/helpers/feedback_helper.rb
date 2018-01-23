# frozen_string_literal: true

require "addressable/uri"

module FeedbackHelper
  def app_display_url
    session[:redirect]
  end
end
