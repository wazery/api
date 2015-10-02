module Github
  module DataFetcher
    include Endpoints

    module_function

    # Fetches watched repos
    # Mainly the hacker's watched repos
    #
    # @param name [String]
    def fetch_watched_repos(name)
      hacker = Hacker.where(name: name)

      conn = Faraday.new(url: github_subscriptions_url(name))

      response = conn.get do |req|
        req.headers = { Authorization: "token #{hacker.public_app_github_access_token}" }
      end

      hacker.watched_repos = (MultiJson.load response.body, symbolize_keys: true)
    end

    # Fetches followed users
    # Mainly the hacker's followed users
    #
    # @param name [String]
    def fetch_followed_users(name)
      hacker = Hacker.where(name: name)

      conn = Faraday.new(url: hacker.following_url)

      response = conn.get do |req|
        req.headers = { Authorization: "token #{hacker.public_app_github_access_token}" }
      end

      hacker.followed_users = (MultiJson.load response.body, symbolize_keys: true)
    end
  end
end
