class Repo
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :full_name, type: String
  field :private, type: Boolean
  field :description, type: String
  field :language, type: String
  field :contributors_url, type: String
  field :created_at_github, type: String
  field :updated_at_github, type: String
  field :raw_data, type: Hash

  # Indexes
  index(name: 1, language: 1)
  index({ full_name: 1 }, unique: true)

  # Relations
  belongs_to :hacker, foreign_key: :hacker_id
end
