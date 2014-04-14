LinkedIn.configure do |config|
  config.token = OMNIAUTH_PROVIDERS["linkedin"][:app_id]
  config.secret = OMNIAUTH_PROVIDERS["linkedin"][:app_secret]
  config.default_profile_fields = ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]
end