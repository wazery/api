# Hacker model, that saves the Github hacker data to a Mongoid document.
class Hacker
  include Mongoid::Document
  include Mongoid::Timestamps
  include Github::Auth

  devise :registerable, :rememberable, :trackable,
         :omniauthable

  field :email, type: String, default: ''

  # Rememberable
  field :remember_created_at, type: Time

  # Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  # Omniauthable
  field :name,               type: String, default: ''
  field :github_token,       type: String, default: ''
  field :github_uid, type: String

  index({ email: 1 }, unique: true, background: true)
  index({ github_token: 1 }, unique: true, background: true)

  # Github Data
  field :raw_data, type: Hash
  field :company, type: String
  field :username, type: String
  field :api_secret, type: String
  field :avatar_url, type: String
  field :display_name, type: String
  field :public_repos, type: Integer
  field :public_gists, type: Integer
  field :current_scope, type: String # '' or 'user, repo'
  field :private_gists, type: Integer
  field :total_private_repos, type: Integer
  field :owned_private_repos, type: Integer
  field :private_app_github_access_token, type: String
  field :public_app_github_access_token, type: String

  # Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: 'is not valid email' }
  validates :name, presence: true
  validates :github_token, presence: true, uniqueness: true

  # Callbacks
  after_initialize :_set_defaults

  class << self
    # Creates the actual hacker into DB.
    #
    # @param data [Hash] the data needed to signup the hacker
    # @return [Hacker] a signed up hacker.
    def sign_up(data)
      Hacker.create(data)
      # TODO: Implement Intercom Notifier
      # IntercomNotifier.perform_in(1.hours, :signed_up_an_hour_ago, hacker.id)
    end
  end

  private

  def _set_defaults
    self.api_secret ||= JWTToken.generate
  end

  def private_access_granted?
    current_hacker.private_app_github_access_token.present?
  end
end
