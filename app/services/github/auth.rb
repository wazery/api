module Github
  # Basic authentication service for Github
  module Auth
    include Endpoints

    module_function

    # Fetches the hacker profile data from Github API
    # based on the access_token
    #
    # @param github_params [String]
    # @return github_profile, access_token [Hash, String]
    def fetch_github_user_profile(github_params)
      access_token = fetch_github_access_token(github_params)

      conn = Faraday.new(url: github_api_base_url)

      response = conn.get '/user' do |req|
        req.headers = { Authorization: "token #{access_token}" }
      end

      MultiJson.load response.body, access_token
    end

    # Fetches an access token from the Github API
    # based on the github_params, which contains the client_id and code.
    #
    # @param github_params [String]
    # @return access_token [String]
    def fetch_github_access_token(github_params)
      conn = Faraday.new(url: github_base_url)

      response = conn.get '/login/oauth/access_token' do |req|
        req.params = github_params
      end

      # TODO: Handle exceptions
      # fail 'Failed fetching access token'
      response.body.match('\=(.*?)\&')[1]
    end
  end
end
