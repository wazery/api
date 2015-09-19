require 'rails_helper'

RSpec.describe Hacker do
  let(:hacker) { FactoryGirl.build :hacker }

  # Test validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:github_token) }
  it { is_expected.to validate_uniqueness_of(:github_token) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_format_of(:email).to_allow('foo@bar.com').not_to_allow(['foo.bar.com', 'foo@bar']) }

  # Test indexes
  it { is_expected.to have_index_for(email: 1).with_options(unique: true, background: true) }
  it { is_expected.to have_index_for(github_token: 1).with_options(unique: true, background: true) }

  # Test document structure
  it { is_expected.to have_fields(:name, :github_token, :email, :current_sign_in_ip, :last_sign_in_ip) }
  it { is_expected.to have_fields(:remember_created_at, :current_sign_in_at, :last_sign_in_at).of_type(Time) }
  it { is_expected.to be_timestamped_document }
end
