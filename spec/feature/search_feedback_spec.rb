# frozen_string_literal: true

require "rails_helper"
require "pry"

RSpec.feature "Search feedback" do
  before do
    reset_application!
    5.times do |n|
      Feedback.create(username: "#{Faker::Name.name}#{n}",
                      contact_email: "email#{n}@va.gov",
                      subject: "Subject#{n}",
                      original_url: "caseflow.ds.va.gov/application/123456789",
                      feedback: Faker::Name.name,
                      veteran_pii: "#{n}#{n}#{Faker::Number.number(7)}")
    end
  end

  scenario "Load Admin Dashboard page" do
    User.authenticate!(roles: ["System Admin"])
    visit "/admin"
    fill_in "search", with: " "
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 5)
    fill_in "search", with: "email1"
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 1)
    fill_in "search", with: "Subject4"
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 1)
    fill_in "search", with: "33"
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 1)
    fill_in "search", with: Time.zone.today.strftime("%m/%d")
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 5)
    fill_in "search", with: "*1*va.gov"
    click_on "search"
    expect(page).to have_css("tbody#feedback tr", count: 1)
  end
end
