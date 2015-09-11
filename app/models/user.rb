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

  def starred_repos
    github.activity.starring.starred
  end

  def followers
    github.users.followers.list
  end

  def followed
    github.users.followers.following
  end

  def commit_dates
    date_times = recent_push_events.map { |event| event.created_at }
    dates = date_times.map { |date_time| date_time.to_date }
    dates
  end

  def followed_commit_dates
    followed_events = followed.map { |user| followed_recent_push_event(user) }
    date_times = followed_events.map { |event| event.created_at }
    dates = date_times.map { |date_time| date_time.to_date }
    dates
  end

  def commit_messages
    commits = recent_push_events.map { |push_event| push_event.payload.commits }
    messages = commits.map { |outer| outer.map { |inner| inner.message } }
    messages
  end

  def followed_commit_messages
    followed_events = followed.map { |user| followed_recent_push_event(user) }
    commits = followed_events.map { |push_event| push_event.payload.commits }
    messages = commits.map { |outer| outer.map { |inner| inner.message } }
    messages
  end

  def organizations
    github.orgs.list(user: self.nickname)
  end

  private

  def github
    Github.new(oauth_token: self.token)
  end

  def recent_push_events
    events = github.activity.events.performed(self.nickname)
    recent_push_events = events.select { |event| event[:type] == "PushEvent" }.first(5)
    recent_push_events
  end

  def followed_recent_push_event(user)
    events = github.activity.events.performed(user.login)
    followed_recent_push_event = events.select { |event| event[:type] == "PushEvent" }.first
    followed_recent_push_event
  end
end
