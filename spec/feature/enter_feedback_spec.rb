require "rails_helper"
require "pry"

RSpec.feature "Enter feedback" do
  before do
    reset_application!
  end

  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    expect(page).to have_css("#feedback_feedback")
    page.should have_link("Cancel")
    fill_in "feedback_feedback", with: "Feedback"
    fill_in "feedback_contact_email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    expect(page).to have_content("Back to Caseflow")
    click_on "Send in more feedback"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    page.should have_link("Back to Caseflow", href: "https://www.va.gov")
  end
end
