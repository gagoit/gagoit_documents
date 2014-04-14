Twitter.configure do |config|
  config.consumer_key = OMNIAUTH_PROVIDERS["twitter"][:app_id]
  config.consumer_secret = OMNIAUTH_PROVIDERS["twitter"][:app_secret]
end