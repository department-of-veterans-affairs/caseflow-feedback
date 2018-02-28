# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Logout" do
  before do
    reset_application!
  end

  scenario "Logging out redirects to home page" do
    visit "feedback/new"
    click_on "ANNE MERICA (283)"
    expect(page).to have_content("Sign out")
    expect(page).to have_selector(:link_or_button, "Sign out")
    click_on "Sign out"
  end
end
