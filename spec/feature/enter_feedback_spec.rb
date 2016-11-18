require "rails_helper"
require "pry"

RSpec.feature "Enter feedback" do
  scenario "Load Feedback page" do
    visit "/feedback/new"
    expect(page).to have_content("Tell us about your experience")
    expect(page).to have_css("#feedback_feedback")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
    click_on "Send in more feedback"
    expect(page).to have_content("Tell us about your experience")
    fill_in "feedback_feedback", with: "Feedback"
    click_on "Send Feedback"
    expect(page).to have_content("Thanks for your feedback!")
  end
end
