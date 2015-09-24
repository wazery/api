module Github
  module Config
    @github_config = Rails.application.config_for('secrets').with_indifferent_access

    module_function

    def github_client_id
      @github_config[:github_client_id]
    end

    def github_client_secret
      @github_config[:github_client_secret]
    end
  end
end
