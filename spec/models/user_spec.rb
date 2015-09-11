require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    user = User.create(nickname: "tgraham777",
                       email:  "twgraham@amgnational.com",
                       provider: "github",
                       token:      ENV['github_oauth'],
                       uid:   123123,
                       image_url: "example.com",
                       )
  end

  scenario "#find_repositories" do
    VCR.use_cassette("user_test#repositories") do

      repos = user.repos
      repo = repos.first

      expect(repos.count).to eq(21)
      expect(repo.name).to eq("active-record-sinatra")
      expect(repo.owner.login).to eq("tgraham777")
    end
  end

  xscenario "#followers" do
    VCR.use_cassette("user_test#followers") do

      followers = user.followers
      follower = followers.first

      expect(followers.count).to eq(1)
      expect(follower.login).to eq("MLee21")
      expect(follower.type).to eq("User")
    end
  end

  xscenario "#following" do
    VCR.use_cassette("user_test#following") do

      followed = user.followed
      follow = followed.first

      expect(followed.count).to eq(5)
      expect(follow.login).to eq("kristinabrown")
      expect(follow.type).to eq("User")
    end
  end

  xscenario "#starred" do
    VCR.use_cassette("user_test#starred") do

      starred_repos = user.starred_repos

      expect(starred_repos.count).to eq(2)
    end
  end

  scenario "#commits" do
    VCR.use_cassette("user_test#commits") do

      commits = user.commits
      commit = commits.first

      expect(commits.count).to eq(8)
      expect(commit.actor.login).to eq("tgraham777")
      expect(commit.payload.commits.first.message).to eq("finishes dashboard styling")
    end
  end

  scenario "#organizations" do
    VCR.use_cassette("user_test#organizations") do

      organizations = user.organizations

      expect(organizations.count).to eq(1)
    end
  end

  xscenario "#find_followed_commit_messages" do
    VCR.use_cassette("user_test#find_recent_commits_for_followed_users") do

      commit_messages = user.followed_commit_messages
      message = commit_messages.first

      expect(message).to eq("pc")
    end
  end

  xscenario "#find_followed_commit_dates" do
    VCR.use_cassette("user_test#find_recent_commits_for_followed_users") do

      commit_dates = user.followed_commit_dates
      commit_date = commit_dates.first

      expect(commit_date).to eq("2015-08-30")
    end
  end

  scenario "#find_scores" do
    VCR.use_cassette("user_test#find_scores") do

      scores = user.find_scores

      expect(scores[0]).to eq(316)
      expect(scores[1]).to eq(4)
      expect(scores[2]).to eq(7)
    end
  end
end
