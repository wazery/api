require 'rails_helper'

RSpec.describe User do
  # Validation Matchers
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:github_token) }
  it { is_expected.to validate_uniqueness_of(:github_token) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_format_of(:email).to_allow('foo@bar.com').not_to_allow(['foo.bar.com', 'foo@bar']) }
end
