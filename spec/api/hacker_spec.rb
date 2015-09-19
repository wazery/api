require 'spec_helper'

describe 'Hacker', type: :request do
  describe 'POST /hacker' do
    let(:hacker) { FactoryGirl.build :hacker }
    let(:persisted_hacker) { Hacker.last }
    let(:request_params) { { hacker: { email: hacker.email, name: hacker.name } } }

    let(:response_body) do
      {
        hacker: {
          id: persisted_hacker.id,
          email: persisted_hacker.email,
          name: persisted_hacker.name,
          token: persisted_hacker.authentication_token,
          sign_in_count: 1
        }
      }
    end

    # test_successful_request
    # test_failed_request_if_missing_params(hacker: [:name, :email, :password])
    # test_failed_request_if_no_params_are_sent
  end
end
