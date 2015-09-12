class UsersController < ApplicationController
  ################# Documentation ######################################################################################
  # api :POST, '/developers/oauth', 'Authenticate user using an OAuth provider'
  # description <<-EOS
  #   returns:{
  #     user: {
  #       id:
  #       token:
  #       email:
  #       name:
  #     }
  #   }
  # EOS
  # param :code, String, required: true
  # error code: 401, desc: 'Authentication failed'
  ################# /Documentation #####################################################################################
  def oauth
    user = User.find_or_create_by_github_oauth_code(params[:code])

    fail 'Authentication failed' unless user

    render json: {user: user.sign_in_formatted}
  rescue => e
    return render json: {message: e.message}, status: 401
  end
end
