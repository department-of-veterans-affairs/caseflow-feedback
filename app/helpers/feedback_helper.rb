module FeedbackHelper
  def app_display_name
    Rails.configuration.app_names[session[:app]]
  end

  def app_display_url
    Rails.configuration.app_urls[session[:app]]
  end
end
