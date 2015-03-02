Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['10d2f062f76642cc01c7'], ENV['3f8ad47891aaa98508e70e3554193fd58ed7e2b1']
end