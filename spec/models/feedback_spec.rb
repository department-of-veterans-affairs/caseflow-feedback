require "rails_helper"

RSpec.describe Feedback, type: :model do
  let(:feedback) { { subject: "eFolder Express", username: "alf", feedback: "gr8 app" } }

  after do
    Feedback.delete_all
  end

  context "#contact_email" do
    it "is required" do
      expect { Feedback.create!(feedback) }.to raise_error
    end

    it "must be in valid format" do
      f = feedback.clone
      f[:contact_email] = "no_at_sign"
      expect { Feedback.create!(f) }.to raise_error
      f[:contact_email] = "yes@sign"
      expect { Feedback.create!(f) }.to raise_error
      f[:contact_email] = "yes@sign.com"
      expect { Feedback.create!(f) }.not_to raise_error
    end
  end
end
