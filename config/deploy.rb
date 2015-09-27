# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'hackhub-api'
set :repo_url, 'git@github.com:wazery/api.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/hackhub-api/'

# Default value for :scm is :git
set :scm, :git

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :format is :pretty
set :format, :pretty

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/mongoid.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

# files we want symlinking to specific entries in shared
set :linked_files, %w(config/mongoid.yml)

# dirs we want symlinking to shared
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system)

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ['spec']

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  mongoid.yml
  log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: 'nginx.conf',
    link: '/etc/nginx/sites-enabled/{{full_app_name}}'
  },
  {
    source: 'unicorn_init.sh',
    link: '/etc/init.d/unicorn_{{full_app_name}}'
  },
  {
    source: 'log_rotation',
    link: '/etc/logrotate.d/{{full_app_name}}'
  },
  {
    source: 'monit',
    link: '/etc/monit/conf.d/{{full_app_name}}.conf'
  }
])

# Slack integration
set :slack_webhook, 'https://hooks.slack.com/services/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'
set :slack_icon_url, -> { 'http://profguys.com/assets/logos/capistrano-a9bacaecad4b9089a5b8defc1449dd6f.png' }
set :slack_username, -> { 'capistrano' }
set :slack_revision, `git rev-parse origin/master`.strip!
set :slack_title_finished, 'Finished deploying'
set :slack_msg_finished, nil
set :slack_fallback_finished, "#{fetch(:slack_deploy_user)} deployed #{fetch(:application)} on #{fetch(:stage)}"
set :slack_fields_finished, [
  {
    'title': 'Project',
    'value': "<https://github.com/XXXXX/#{fetch(:application)}|#{fetch(:application)}>",
    'short': true
  },
  {
    'title': 'Environment',
    'value': fetch(:stage),
    'short': true
  },
  {
    'title': 'Deployer',
    'value': fetch(:slack_deploy_user),
    'short': true
  },
  {
    'title': 'Revision',
    'value': "<https://github.com/XXXXX/#{fetch(:application)}/commit/#{fetch(:slack_revision)}|#{fetch(:slack_revision)[0..6]}>",
    'short': true
  }
]

# Airbrush configurations
Airbrussh.configure do |config|
  config.command_output = true
end

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, 'deploy:check_revision'
  before :deploy, 'deploy:setup_config' # Temporarily setup config each time

  # only allow a deploy with passing tests to deployed
  # TODO: Enable this
  # before :deploy, "deploy:run_tests"

  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end
