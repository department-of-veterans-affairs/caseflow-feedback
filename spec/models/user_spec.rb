User.authentication_service = Fakes::AuthenticationService

describe User do
  let(:session) { { "user" => { "id" => "DSUSER", "station_id" => "456" } } }
  let(:user) { User.from_session(session) }
  before do
    Fakes::AuthenticationService.user_session = nil
    User.unauthenticate!
  end

  context "#display_name" do
    subject { user.display_name }

    context "when username and station id are both set" do
      before do
        session["user"]["id"] = "Shaner"
        user.station_id = "7"
      end
      it { is_expected.to eq("Shaner (7)") }
    end
  end

  context "#admin?" do
    subject { user.admin? }

    context "when user is not an admin" do
      before { session["user"]["roles"] = nil }
      it { is_expected.to be_falsey }
    end

    context "when user is admin" do
      before { User.authenticate!(roles: ["System Admin"]) }
      it { is_expected.to be_truthy }
    end
  end

  context "#authenticated?" do
    subject { user.authenticated? }
    before { session[:username] = "USER" }

    context "when station_id set" do
      before { user.station_id = "7" }
      it { is_expected.to be_truthy }
    end

    context "when station_id isn't set" do
      before { user.station_id = nil }
      it { is_expected.to be_falsy }
    end
  end

  context ".from_session" do
    subject { User.from_session(session) }
    context "gets a user object from a session" do
      before do
        session["user"]["roles"] = ["Do the thing"]
        session[:regional_office] = "283"
      end

      it do
        is_expected.to be_an_instance_of(User)
        expect(subject.roles).to eq(["Do the thing"])
        expect(subject.regional_office).to eq("283")
      end
    end

    context "returns nil when no user in session" do
      before { session["user"] = nil }
      it { is_expected.to be_nil }
    end
  end
end
