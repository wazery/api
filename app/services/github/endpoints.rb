module Github
  module Endpoints
    @endpoints = {
      base: 'https://github.com',
      api_base: 'https://api.github.com',
      auth: 'https://github.com/login/oauth/authorize',
      token_exchange: 'https://github.com/login/oauth/access_token'
    }

    # Returns all of the endpoints, for easy listing
    #
    # @return [endpoints:Hash] a hash that contains all of the Github endpoints.
    def self.endpoints
      @endpoints
    end

    module_function

    # Github Endpoints URL methods
    @endpoints.each do |meth, val|
      define_method("github_#{meth}_url") { val }
    end
  end
end
