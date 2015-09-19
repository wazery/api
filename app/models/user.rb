# User User model, that saves the Github user data to a Mongoid doc.
# @author Islam Wazery <wazery@ubuntu.com>
# @author Mohamed Yossry <mohamedyosry3000@gmail.com>
class User
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
  # field :provider,           type: String, default: ''
  # field :uid,                type: String, default: ''
  field :name,               type: String, default: ''
  field :github_token,       type: String, default: ''

  index({ email: 1 }, unique: true, background: true)
  # index({ uid: 1 },          unique: true, background: true)
  index({ github_token: 1 }, unique: true, background: true)

  # Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: 'is not valid email' }
  validates :name, presence: true
  validates :github_token, presence: true, uniqueness: true

  # Class Attributes
  cattr_writer :octokit
  cattr_writer :octokit_client

  def self.octokit
    @@octokit || Octokit
  end

  def self.octokit_client
    @@octokit_client || Octokit::Client
  end

  def self.github_client(access_token)
    octokit_client.new(access_token: access_token)
  end

  def self.sign_up(data)
    User.create(data)
    # TODO: Implement Intercom Notifier
    # IntercomNotifier.perform_in(1.hours, :signed_up_an_hour_ago, user.id)
  end

  def self.find_or_create_by_github_oauth_code(code)
    access_token = fetch_github_access_token(code)

    user = find_by_github_access_token(access_token)
    return user if user

    user = sign_up(info_by_github_access_token(access_token))
    user
  end

  def self.find_by_github_access_token(access_token)
    where(github_token: access_token).first
  end

  def self.info_by_github_access_token(access_token)
    client = github_client(access_token)
    user   = client.user

    # cached_emails = REDIS.get(github_emails_cache_key(access_token))
    # emails = JSON.parse(cached_emails) if cached_emails
    email = client.emails.first[:email] # unless cached_emails
    # TODO: Check why reject those emails?
    # emails = emails.reject { |email| email =~ /@users\.noreply\.github\.com$/ }

    name = user.name.blank? ? email.partition('@').first : user.name

    { email: emails, name: name, github_token: access_token }
  end

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

  private

  def fetch_github_access_token(code)
    ret = octokit.exchange_code_for_token(code)

    return ret[:access_token] if ret[:access_token]
    # TODO: Handling exception
    fail ret[:error_description] if ret[:error]
    fail 'Falied fetching access token'
  end
end
