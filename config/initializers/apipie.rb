Apipie.configure do |config|
  config.app_name                = 'HackHub'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apipie'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/web/*.rb"

  config.validate     = false
  config.authenticate = proc do
    authenticate_or_request_with_http_basic do |username, password|
      [username, password] == [Api::Application::HTTP_AUTH_USERNAME, Api::Application::HTTP_AUTH_PASSWORD]
    end
  end
end
