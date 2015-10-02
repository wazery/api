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

      hacker.watched_repos = formatted_hash(watched_repos, [
        :id, :name, :full_name, :private, :url, :issue_events_url, :events_url
      ])
      hacker.save
    end

    # Fetches followed users
    # Mainly the hacker's followed users
    #
    # @param name [String]
    def fetch_followed_users(name, github_token)
      hacker = Hacker.where(name: name, github_token: github_token).first

      conn = Faraday.new(url: hacker.raw_data[:following_url].gsub(/(\{\/other_user\})/, ''))
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

      hacker.followed_users = formatted_hash(followed_users, [
        :id, :login, :url, :avatar_url, :events_url
      ])
      hacker.save
    end

    private_class_method
    # Gets just the keys we want to persist
    #
    # @param obj [Array] the array that needs to be formatted
    # @param keys [Array] array of keys as symbols
    def formatted_hash(obj, keys)
      obj[0].map do |hash|
        {}.tap do |new_hash|
          keys.each { |key| new_hash[key] = hash[key] }
        end
      end
    end
  end
end
