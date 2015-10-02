module Github
  module DataFetcher
    module_function

    # Fetches watched repos
    # Mainly the hacker's watched repos
    #
    # @param name, github_token [String, String] hacker's name, GitHub token
    def fetch_watched_repos(name, github_token)
      hacker = Hacker.where(name: name, github_token: github_token).first

      conn = Faraday.new(url: hacker.raw_data[:subscriptions_url])
      watched_repos = []

      10_000.times.each do |page|
        response =
          conn.get do |req|
            req.headers = { Authorization: "token #{hacker.github_token}" }

            next_page = page + 1
            req.params = {
              page: next_page,
              per_page: 100,
              sort: 'pushed'
            }
            Rails.logger.info "Scrapped the page ##{next_page}"
          end
        fail ::ExceedRateLimit if response.headers['x-ratelimit-remaining'] == '0'
        break if response.body == '[]'
        watched_repos << (MultiJson.load response.body, symbolize_keys: true)
      end

      hacker.watched_repos = watched_repos
      hacker.save
    end

    # Fetches followed users
    # Mainly the hacker's followed users
    #
    # @param name [String]
    def fetch_followed_users(name, github_token)
      hacker = Hacker.where(name: name, github_token: github_token).first

      conn = Faraday.new(url: hacker.raw_data[:following_url].gsub(%{/(\{\/other_user\})/}, ''))
      followed_users = []

      10_000.times.each do |page|
        response =
          conn.get do |req|
            req.headers = { Authorization: "token #{hacker.github_token}" }

            next_page = page + 1
            req.params = {
              page: next_page,
              per_page: 100
            }
            Rails.logger.info "Scrapped the page ##{next_page}"
          end
        fail ::ExceedRateLimit if response.headers['x-ratelimit-remaining'] == '0'
        break if response.body == '[]'
        followed_users << (MultiJson.load response.body, symbolize_keys: true)
      end

      hacker.followed_users = followed_users
      hacker.save
    end
  end
end
