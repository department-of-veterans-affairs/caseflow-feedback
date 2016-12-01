require "rails_helper"

RSpec.feature "Admin Page " do
  before do
    reset_application!
  end

  scenario "User who is not admin" do
    User.authenticate!(roles: ["non-admin"])
    visit "/admin"
    expect(page).to have_content("Unauthorized")
  end

  scenario "User who is admin" do
    User.authenticate!(roles: ["System Admin"])
    visit "/admin"
    expect(page).to have_content("User")
    expect(page).to have_content("Date")
    expect(page).to have_content("Application")
    expect(page).to have_content("Feedback")
    expect(page).to have_no_content("Unauthorized")
  end

  scenario "Post feedback and make sure it shows on Feedback View" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Dispatch")
    expect(page).to have_css("#feedback_feedback")
    page.should have_link("Cancel")
    fill_in "feedback_feedback", with: "Feedback Posting Test"
    fill_in "feedback_contact_email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    click_on "Send in more feedback"
    expect(page).to have_content("Tell us about your experience with Dispatch")
    fill_in "feedback_feedback", with: "Feedback Posting Test 2"
    # leave contact email field empty
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    User.authenticate!(roles: ["System Admin"])
    visit "/admin"
    expect(page).to have_content("fk@va.gov")
    expect(page).to have_content(Date.current.strftime("%m/%d/%Y"))
    expect(page).to have_content("Dispatch")
    expect(page).to have_content("Feedback Posting Test")
    expect(page).to have_content("ANNE MERICA (283)")
    expect(page).to have_content("Dispatch")
    expect(page).to have_content("Feedback Posting Test 2")
  end
end
