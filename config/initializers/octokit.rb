require 'octokit'

github_config = Rails.application.config_for('github').with_indifferent_access

Octokit.configure do |c|
  c.client_id     = github_config[:client_id]
  c.client_secret = github_config[:client_secret]
end
