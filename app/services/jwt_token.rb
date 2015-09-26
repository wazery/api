# Generate JWT token
module JWTToken
  extend Config

  module_function

  # Creates the payload with 32 char random token, and one month expiration time.
  # Then it encode the payload with a JWT secret token
  #
  # @return code [String]
  def generate
    payload = {
      sub: (MicroToken.generate 32),
      iat: Time.now.to_i,
      exp: (Time.now.to_i + app_token_ttl.to_i)
    }
    JWT.encode(payload, app_jwt_token_secret)
  end
end
