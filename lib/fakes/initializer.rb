# frozen_string_literal: true

class Fakes::Initializer
  def self.development!
    User.authentication_service = Fakes::AuthenticationService
    User.authentication_service.vacols_regional_offices = {
      "DSUSER" => "DSUSER",
      "RO13" => "RO13"
    }

    User.authentication_service.user_session = {
      "id" => "ANNE MERICA",
      "roles" => ["Certify Appeal", "Establish Claim", "Manage Claim Establishment", "System Admin"],
      "station_id" => "283"
    }
  end
end
