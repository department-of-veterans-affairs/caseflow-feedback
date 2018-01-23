# frozen_string_literal: true

class Fakes::AuthenticationService
  cattr_accessor :user_session
  cattr_accessor :vacols_regional_offices

  def self.default_user_session
    user_session
  end
end
