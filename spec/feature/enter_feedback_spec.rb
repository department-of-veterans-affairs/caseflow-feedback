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
    expect(page).to have_content("Your comments will help us improve Caseflow for everyone. (Required)")
    expect(page).to have_content("Contact email (Required)")
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
    fill_in "feedback_contact_email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    page.should have_link("Back to Caseflow", href: "caseflow.ds.va.gov")
  end

  scenario "Validate Input Fields" do
    visit "/feedback/new"
    click_on "Send Feedback"
    expect(page).to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    screenshot_and_save_page
    fill_in "feedback_feedback", with: "Feedback"
    fill_in "feedback_contact_email", with: "fk@va"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).to have_content("Make sure you’ve entered a valid email address below.")
    fill_in "feedback_contact_email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).not_to have_content("Make sure you’ve filled out the comment box below.")
    expect(page).not_to have_content("Make sure you’ve entered a valid email address below.")
  end
end
