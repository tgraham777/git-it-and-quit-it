require 'rails_helper'

RSpec.describe "user" do
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  xscenario "can view dashboard" do
    VCR.use_cassette("user_dashboard_test#render") do
      visit root_path
      login
      click_link "Login with Github"

      expect(page).to have_content("Profile")
      expect(page).to have_content("Repositories")
      expect(page).to have_content("My Recent Commits")
      expect(page).to have_content("Followed Users' Recent Commits")
      expect(page).to have_content("My Organizations")
      expect(page).to have_content("My Contributions")

      expect(page).to have_content("tgraham777")
      expect(page).to have_content("tylergraham134@gmail.com")
      expect(page).to have_content("Number of starred repos: 2")
      expect(page).to have_content("MLee21")
      expect(page).to have_content("kristinabrown")

      expect(page).to have_content("active-record-sinatra")
      expect(page).to have_content("blogger")

      expect(page).to have_content("tgraham777/git-it-and-quit-it")

      expect(page).to have_content("turingschool")

      expect(page).to have_content("Contributions in the past year")
      expect(page).to have_content("Current streak")
      expect(page).to have_content("Longest streak")
    end
  end
end
