Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, "ee2dde4ccf071151ba27", "64fc8ea43f67c3760ada1c99d6f6250683ef7110"
end
