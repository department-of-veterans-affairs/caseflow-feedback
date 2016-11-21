require "rails_helper"
require "pry"

RSpec.feature "Enter feedback" do
  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow Certification")
    expect(page).to have_css("#feedback_feedback")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    expect(page).to have_content("Back to Caseflow Certification")
    click_on "Send in more feedback"
    expect(page).to have_content("Tell us about your experience with Caseflow Certification")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    expect(page).to have_content("Back to Caseflow Certification")
    page.should have_link("Back to Caseflow Certification", href: "https://caseflow.ds.va.gov")
  end
end
