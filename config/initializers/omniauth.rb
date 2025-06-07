Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :discord, Rails.application.credentials.dig(:discord, :client_id), Rails.application.credentials.dig(:discord, :client_secret), scope: "identify email"
end

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
