class User
  include ActiveModel::Model
  # Ephemeral values obtained from CSS on auth. Stored in user's session
  attr_accessor :roles, :css_id, :station_id
  attr_writer :regional_office

  # TODO (alex): we should move this out into a VACOLS data gem, or into caseflow-commons.
  STATIONS = {
    "301" => "RO01",
    "402" => "RO02",
    "304" => "RO04",
    "405" => %w(RO05 RO03),
    "306" => "RO06",
    "307" => %w(RO07 RO91),
    "308" => "RO08",
    "309" => "RO09",
    "310" => %w(RO10 RO74 RO80 RO81 RO84),
    "311" => %w(RO11 RO71),
    "313" => "RO13",
    "314" => "RO14",
    "315" => "RO15",
    "316" => %w(RO16 RO87 RO92),
    "317" => "RO17",
    "318" => %w(RO18 RO88),
    "319" => "RO19",
    "320" => "RO20",
    "321" => "RO21",
    "322" => "RO22",
    "323" => "RO23",
    "325" => "RO25",
    "326" => "RO26",
    "327" => "RO27",
    "328" => "RO28",
    "329" => "RO29",
    "330" => %w(RO30 RO75 RO82 RO85),
    "331" => "RO31",
    "333" => "RO33",
    "334" => "RO34",
    "335" => %w(RO35 RO76 RO83),
    "436" => "RO36",
    "437" => "RO37",
    "438" => "RO38",
    "339" => "RO39",
    "340" => "RO40",
    "341" => "RO41",
    "442" => "RO42",
    "343" => "RO43",
    "344" => "RO44",
    "345" => "RO45",
    "346" => "RO46",
    "347" => "RO47",
    "348" => "RO48",
    "349" => "RO49",
    "350" => "RO50",
    "351" => %w(RO51 RO93 RO94),
    "452" => "RO52",
    "354" => "RO54",
    "355" => "RO55",
    "358" => "RO58",
    "459" => "RO59",
    "460" => "RO60",
    "362" => "RO62",
    "363" => "RO63",
    "372" => "RO72",
    "373" => "RO73",
    "377" => "RO77",
    "283" => "DSUSER"
  }.freeze


  def username
    css_id
  end

  # If RO is unambiguous from station_office, use that RO. Otherwise, use user defined RO
  def regional_office
    station_offices.is_a?(String) ? station_offices : @regional_office
  end

  def display_name
    # fully authenticated
    if authenticated?
      "#{username} (#{regional_office})"

    # just SSOI, not yet vacols authenticated
    else
      username.to_s
    end
  end

  def can?(thing)
    return false if roles.nil?
    return true if roles.include? "System Admin"
    roles.include? thing
  end

  def authenticated?
    !regional_office.blank?
  end

  # This method is used for VACOLS authentication
  def authenticate(regional_office:, password:)
    return false unless User.authenticate_vacols(regional_office, password)

    @regional_office = regional_office.upcase
  end

  private

  def station_offices
    STATIONS[station_id]
  end

  class << self
    attr_writer :authentication_service
    delegate :authenticate_vacols, to: :authentication_service

    def from_session(session)
      user = session["user"] ||= authentication_service.default_user_session
      return nil if user.nil?

      new(css_id: user["id"],
          station_id: user["station_id"],
          roles: user["roles"],
          regional_office: user["regional_office"])
    end

    def authentication_service
      @authentication_service ||= AuthenticationService
    end
  end
end
