# frozen_string_literal: true

require "rails_helper"

RSpec.describe Feedback, type: :model do
  let(:feedback_no_email) { { subject: "eFolder Express", username: "alf", feedback: "gr8 app" } }
  let(:feedback) { { subject: "eFolder Express", username: "alf", feedback: "gr8 app", contact_email: "fk@va.gov" } }

  after do
    Feedback.delete_all
  end

  context "#feedback" do
    it "must prevent sensitive leak" do
      f = feedback.clone
      f[:feedback] = "123456789"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "123456789S"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "123 45 6789"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "123-45-6789"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "01234567C"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "1234567C"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "01234567"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "1234567"
      expect { Feedback.create!(f) }.to raise_error
      f[:feedback] = "1234567890"
      expect { Feedback.create!(f) }.not_to raise_error
      f[:feedback] = "123456"
      expect { Feedback.create!(f) }.not_to raise_error
      f[:feedback] = "2022007317"
      expect { Feedback.create!(f) }.not_to raise_error
      f[:feedback] = "202-200-7317"
      expect { Feedback.create!(f) }.not_to raise_error
      f[:feedback] = "(202) 200-7317"
      expect { Feedback.create!(f) }.not_to raise_error
    end
  end

  context "#contact_email" do
    it "is required" do
      expect { Feedback.create!(feedback_no_email) }.to raise_error
    end

    it "must have email in valid format" do
      f = feedback_no_email.clone
      f[:contact_email] = "no_at_sign"
      expect { Feedback.create!(f) }.to raise_error
      f[:contact_email] = "yes@sign"
      expect { Feedback.create!(f) }.to raise_error
      f[:contact_email] = "yes@sign.com"
      expect { Feedback.create!(f) }.not_to raise_error
    end
  end

  context "callbacks" do
    it "should update github url after feedback is created" do
      expect(Feedback.create(feedback).github_url).to_not eq nil
    end
  end

  context "#render_issue_template" do
    it "should generate template correctly" do
      feedback[:contact_email] = "test@example.com"
      result = Feedback.create(feedback).render_issue_template
      expect(result).to match(/alf/)
      expect(result).to match(/test@example.com/)
      expect(result).not_to match(/gr8 app/)
    end
  end

  context "#github_labels" do
    it "it recognizes the subject" do
      labels = "Source - Feedback, Current Sprint, eFolder"
      expect(Feedback.create(feedback).github_labels).to eq labels
    end

    it "it does not recognize the subject" do
      labels = "Source - Feedback, Current Sprint"
      feedback = Feedback.create(subject: "other", username: "alf", feedback: "gr8 app")
      expect(feedback.github_labels).to eq labels
    end
  end

  context "#issue_number" do
    it "returns issue number" do
      expect(Feedback.create(feedback).issue_number).to eq "95"
    end
  end
end
