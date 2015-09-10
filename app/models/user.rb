class User < ActiveRecord::Base
  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.nickname = auth.info.nickname
    user.image_url = auth.info.image
    user.token = auth.credentials.token
    user.save

    user
  end

  def repos
    Github.repos.list(user: self.nickname)
  end

  def find_starred_repos
    github_auth.activity.starring.starred
  end

  private

  def github_auth
    Github.new(oauth_token: self.token)
  end
end
