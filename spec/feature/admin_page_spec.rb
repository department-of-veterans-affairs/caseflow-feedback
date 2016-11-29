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
    puts User.current_user.roles
    expect(page).to have_content("User")
    expect(page).to have_content("Date")
    expect(page).to have_content("Application")
    expect(page).to have_content("Feedback")
    expect(page).to have_no_content("Unauthorized")
  end
end
