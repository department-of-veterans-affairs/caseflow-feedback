require "rails_helper"
require "pry"

RSpec.feature "Enter feedback" do
  before do
    reset_application!
  end

  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    expect(page).to have_content("What's working well? What's not working?")
    expect(page).to have_content("Your comments will help us improve Caseflow for everyone.")
    expect(page).to have_content("Contact email")
    expect(page).to have_css("#feedback_feedback")
    page.should have_link("Cancel")
    fill_in "What's working well?", with: "Enter Feedback Spec"
    fill_in "Contact email", with: "fk@va.gov"
    fill_in "If you are having an issue", with: "Veteran PII"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    expect(page).to have_content("Back to Caseflow")
    click_on "Send in more feedback"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    fill_in "What's working well?", with: "Feedback"
    fill_in "Contact email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    page.should have_link("Back to Caseflow", href: "caseflow.ds.va.gov")
  end

  scenario "Validate Input Fields" do
    visit "/feedback/new"
    click_on "Send Feedback"
    expect(page).to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    fill_in "What's working well?", with: "Feedback"
    fill_in "Contact email", with: "fk@va"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    fill_in "Contact email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).not_to have_content("Make sure you’ve entered a valid email address below.")
  end
end
