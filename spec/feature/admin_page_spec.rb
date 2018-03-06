# frozen_string_literal: true

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
    expect(page).to have_content("Current Feedback")
    expect(page).to have_content("User")
    expect(page).to have_content("Date")
    expect(page).to have_content("Application")
    expect(page).to have_content("Feedback")
    expect(page).to have_no_content("Unauthorized")
  end

  scenario "Post feedback and make sure it shows on Feedback View" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    expect(page).to have_css("#feedback_feedback")
    expect(page).to have_link("Cancel")
    fill_in "Add your comments", with: "Admin Page Spec"
    fill_in "Contact email", with: "fk@va.gov"
    click_on "Send Feedback"
    expect(page).to have_content("Thank you")
    click_on "Send more feedback"
    expect(page).to have_content("Tell us about your experience with Caseflow")
    User.authenticate!(roles: ["System Admin"])
    visit "/admin"
    expect(page).to have_link("95")
    expect(page).to have_content("fk@va.gov")
    expect(page).to have_content(Date.current.strftime("%m/%d/%Y"))
    expect(page).to have_content("Caseflow")
    expect(page).to have_content("Admin Page Spec")
    expect(page).to have_content("DSUSER (283)")
    expect(page).to have_content("Caseflow")
    expect(Feedback.find_by(feedback: "Admin Page Spec").github_url).to_not eq nil
  end

  scenario "Set Raven user context without errors" do
    stub_const("ENV", ENV.to_hash.merge("SENTRY_DSN" => "asdf"))
    User.authenticate!(roles: ["System Admin"])
    visit "/admin"
    expect(page).to have_content("User")
  end
end
