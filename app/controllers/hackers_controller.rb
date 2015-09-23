require 'open-uri'

class HackersController < ApplicationController
  # Documentation
  api :POST, '/hackers/oauth', 'Authenticate hacker using an OAuth provider'
  description <<-EOS
    returns:{
      hacker: {
        id:
        token:
        email:
        name:
      }
    }
  EOS
  param :code, String, required: true
  error code: 401, desc: 'Authentication failed'
  # /Documentation
  def oauth
    hacker = Hacker.find_or_create_by_github_oauth_code(params[:code])

    fail 'Authentication failed' unless hacker

    render json: { hacker: hacker.sign_in_formatted }
  rescue => e
    return render json: { message: e.message }, status: 401
  end
end
