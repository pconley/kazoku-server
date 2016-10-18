Rails.application.configure do
	config.x.auth0.client_id      = ENV['AUTH0_CLIENT_ID']
	config.x.auth0.client_secret  = ENV['AUTH0_CLIENT_SECRET']
end