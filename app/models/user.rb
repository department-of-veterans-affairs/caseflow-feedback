class User
  include ActiveModel::Model
  # Ephemeral values obtained from CSS on auth. Stored in user's session
  attr_accessor :roles, :css_id, :station_id, :regional_office

  def username
    css_id
  end

  # If RO is unambiguous from station_office, use that RO. Otherwise, use user defined RO

  def display_name
    # This display name is different from others.
    # We'll display the station id here, not the regional office,
    # since we don't connect to VACOLS.
    "#{username} (#{station_id})"
  end

  def can?(thing)
    return false if roles.nil?
    return true if roles.include? "System Admin"
    roles.include? thing
  end

  def authenticated?
    !station_id.blank?
  end

  class << self
    attr_writer :authentication_service

    def from_session(session)
      user = session["user"] ||= authentication_service.default_user_session
      return nil if user.nil?

      new(css_id: user["id"],
          station_id: user["station_id"],
          roles: user["roles"],
          regional_office: user["regional_office"] || session[:regional_office])
    end

    def authentication_service
      @authentication_service ||= AuthenticationService
    end
  end
end
