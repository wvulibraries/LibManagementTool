Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas,
         host:      'sso.wvu.edu',
         login_url: '/cas/login',
         service_validate_url: '/cas/serviceValidate'
end
