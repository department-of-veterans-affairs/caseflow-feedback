require "rails_helper"

RSpec.feature "Logout" do
  before do
    reset_application!
  end

  scenario "Logging out redirects to home page" do
    visit "feedback/new"
    expect(page).to have_content("Tell us about your experience with Caseflow.")
    expect(page).to have_content("ANNE MERICA (283)")
    click_on "ANNE MERICA (283)"
    click_on "Sign out"
    expect(page).to have_content("Tell us about your experience with Caseflow.")
  end
end
