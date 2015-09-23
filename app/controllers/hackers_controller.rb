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

  # Documentation
  api :GET, '/hackers/auth', 'Authenticate hacker using Github OAuth'
  description 'Redirects to the authorization URL'
  param :code, String, required: true
  # /Documentation
  def auth
    redirect_to github_auth_url
  end

  # Documentation
  api :POST, '/hackers/callback', 'Authenticate hacker using an OAuth provider'
  description ''
  param :code, String, required: true
  # /Documentation
  def callback
    hacker = Hacker.find_or_create_by_github_oauth_code(params[:code])

    fail 'Authentication failed' unless hacker

    redirect_to 'https://github.com'
  end

  private

  def scopes
    # TODO: Return different scopes depending on the auth phase
    'user:email,repo'
  end

  def redirect_uri
    "#{root_url}/auth/callback?agent=&redirect=https://github.com"
  end

  def github_auth_url
    URI.encode("https://github.com/login/oauth/authorize?response_type=code&redirect_uri=#{redirect_uri}&scope=#{scopes}&client_id=#{Octokit.client_id}")
  end
end
