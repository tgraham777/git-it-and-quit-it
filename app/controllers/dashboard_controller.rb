class DashboardController < ApplicationController
  before_action :authorize!

  def show
    @repos = current_user.repos
    @starred_repos = current_user.find_starred_repos
  end
end
