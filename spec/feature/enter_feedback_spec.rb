require "rails_helper"
require "pry"

RSpec.feature "Enter Feedback" do
  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("We welcome your feedback.")
    expect(page).to have_css("#feedback_feedback")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
  end
end
