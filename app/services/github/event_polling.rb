require 'polling'

module Github
  # Polling service for hacker events
  module EventPolling
    extend Endpoints

    module_function

    def events(github_uid)
      hacker = Hacker.where(github_uid: github_uid).first

      conn = Faraday.new(url: github_user_events_url(hacker.name))

      poll_interval = 60

      Polling.start poll_interval do
        # Do conditional requests by
        # checking the ETag header first
        unless etag
          response = conn.get do |req|
            req.headers = { Authorization: "token #{hacker.github_token}" }
          end
          fail ::ExceedRateLimit if response.headers['x-ratelimit-remaining'] == '0'
          poll_interval = response.headers['X-Poll-Interval']
          etag = response.headers['ETag']
        end
      end

      # TODO: Terminate polling when user is not listening

      (MultiJson.load response.body, symbolize_keys: true)

      # TODO: Pass the response to the parser
    end
  end
end
