require "rails_helper"

RSpec.describe Feedback, type: :model do
  let(:feedback) { { application: "eFolder Express", username: "alf", feedback: "gr8 app" } }

  after do
    Feedback.delete_all
  end

  context "#contact_email" do
    it "is not required" do
      expect { Feedback.create!(feedback) }.not_to raise_error
    end

    it "must have @ sign" do
      f = feedback.clone
      f[:contact_email] = "no_at_sign"
      expect { Feedback.create!(f) }.to raise_error
      f[:contact_email] = "yes@sign"
      expect { Feedback.create!(f) }.not_to raise_error
    end
  end
end
