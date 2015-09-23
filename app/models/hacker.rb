# Hacker model, that saves the Github hacker data to a Mongoid document.
class Hacker
  include Mongoid::Document
  include Mongoid::Timestamps
  devise :registerable, :rememberable, :trackable,
         :omniauthable

  field :email, type: String, default: ''

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Omniauthable
  field :name,               type: String, default: ''
  field :github_token,       type: String, default: ''

  index({ email: 1 }, unique: true, background: true)
  index({ github_token: 1 }, unique: true, background: true)

  # Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: 'is not valid email' }
  validates :name, presence: true
  validates :github_token, presence: true, uniqueness: true

  # Class Attributes
  cattr_writer :octokit
  cattr_writer :octokit_client

  # Returns the formatted signed in hacker object
  #
  # @return [Hash] the formatted hacker object
  def sign_in_formatted
    {
      id: id,
      token: github_token,
      email: email,
      name: name,
      sign_in_count: sign_in_count,
      created_at: created_at
    }
  end

  class << self
    def octokit
      @@octokit || Octokit
    end

    # Returns the Octokit client object or create a new one.
    #
    # @return [Octokit::Client] the Octokit client object.
    def octokit_client
      @@octokit_client || Octokit::Client
    end

    # Returns the Github client object.
    #
    # @param access_token [String] the Github access token
    # @return [Octokit::Client] the Octokit::Client object with the proper access token.
    def github_client(access_token)
      octokit_client.new(access_token: access_token)
    end

    # Returns the hacker signed up.
    #
    # @param data [Hash] the data needed to signup the hacker
    # @return [Hacker] a signed up hacker.
    def sign_up(data)
      Hacker.create(data)
      # TODO: Implement Intercom Notifier
      # IntercomNotifier.perform_in(1.hours, :signed_up_an_hour_ago, hacker.id)
    end

    def find_or_create_by_github_oauth_code(code)
      access_token = fetch_github_access_token(code)

      hacker = find_by_github_access_token(access_token)
      return hacker if hacker

      hacker = sign_up(info_by_github_access_token(access_token))
      hacker
    end

    def find_by_github_access_token(access_token)
      where(github_token: access_token).first
    end

    def info_by_github_access_token(access_token)
      client = github_client(access_token)
      hacker = client.user

      # cached_emails = REDIS.get(github_emails_cache_key(access_token))
      # emails = JSON.parse(cached_emails) if cached_emails
      email = client.emails.first[:email] # unless cached_emails
      # TODO: Check why reject those emails?
      # emails = emails.reject { |email| email =~ /@hackers\.noreply\.github\.com$/ }

      name = hacker.name.blank? ? email.partition('@').first : hacker.name

      { email: email, name: name, github_token: access_token }
    end

    private

    def fetch_github_access_token(code)
      ret = octokit.exchange_code_for_token(code)

      return ret[:access_token] if ret[:access_token]

      # TODO: Handling exception
      fail ret[:error_description] if ret[:error]
      fail 'Falied fetching access token'
    end
  end
end
