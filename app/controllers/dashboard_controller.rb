class DashboardController < ApplicationController
  before_action :authorize!

  def show
    @repos = current_user.repos
    @starred_repos = current_user.starred_repos
    @followers = current_user.followers
    # @followed = current_user.followed
  end
end
