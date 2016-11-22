module FeedbackHelper
  def app_display_name
    #Extracts domain name from entire url
    app_domain = Addressable::URI.parse(session[:app_url]).host
    #Finds application name based on domain
    Rails.configuration.app_names[app_domain]
  end

  def app_display_url
    session[:app_url]
  end
end
