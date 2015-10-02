class BasicDataWorker
  ExceedRateLimit = Class.new(Exception)

  include Sidekiq::Worker

  sidekiq_options retry: false

  # Performs fetching watched repos and fetching followed users
  # This method is used in Hacker model fetch basic data
  #
  # @param name [String] current hacker's name
  # @param type [String]
  def perform(name)
    begin
      Rails.logger.info "Fetching #{name}'s watched repos..."
      Github::DataFetcher.fetch_watched_repos(name)
      Rails.logger.info "Successfully fetched watched repos of #{name}"
    rescue ExceedRateLimit
      Rails.logger.info "Failed, can't fetch watched repos of #{name}. We'll try again in a hour!"
      self.class.perform_in(60.minutes, *args)
    end

    begin
      Rails.logger.info "Fetching #{name}'s followed users..."
      Github::DataFetcher.fetch_followed_users(name)
      Rails.logger.info "Successfully fetched followed users of #{name}"
    rescue ExceedRateLimit
      Rails.logger.info "Failed, can't fetch followed users of #{name}. We'll try again in a hour!"
      self.class.perform_in(60.minutes, *args)
    end
  end
end
