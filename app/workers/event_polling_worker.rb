class EventPollingWorker

  include Sidekiq::Worker

  sidekiq_options retry: false

  # Performs fetching watched repos and fetching followed users
  # This method is used in Hacker model to fetch basic data
  #
  # @param name [String] current hacker's name
  # @param type [String]
  def perform(name, github_token)
    begin
      Rails.logger.info "Start polling #{name}'s events..."
      Github::DataFetcher.fetch_watched_repos(name, github_token)
    rescue ExceedRateLimit
      Rails.logger.info "Failed, can't poll #{name}'s events. We'll try again in a hour!"
      Rails.logger.info 'Because rate limit is exeeded'
      self.class.perform_in(60.minutes, *args)
    end
  end
end
