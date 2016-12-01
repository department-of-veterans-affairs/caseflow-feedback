require "addressable/uri"

module FeedbackHelper
  def app_display_url
    session[:redirect]
  end
end
