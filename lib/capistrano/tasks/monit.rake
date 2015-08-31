namespace :monit do
  # desc "Install Monit"
  # task :install do
  #   run "#{sudo} apt-get -y install monit"
  # end
  # after "deploy:install", "monit:install"

  # desc 'Setup all Monit configuration'
  # task :setup do
  #   nginx
  #   unicorn
  #   monit_config "nginx"
  #   syntax
  #   reload
  # end
  # after "deploy:setup", "monit:setup"

  # task(:nginx, roles: :web) { monit_config "nginx" }
  # task(:unicorn, roles: :app) { monit_config "unicorn" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:app) do
        sudo "service monit #{command}"
      end
    end
  end
end

# def monit_config(name, destination = nil)
#   destination ||= "/etc/monit/conf.d/#{name}.conf"
#   template "monit/#{name}.erb", "/tmp/monit_#{name}"
#   run "#{sudo} mv /tmp/monit_#{name} #{destination}"
#   run "#{sudo} chown root #{destination}"
#   run "#{sudo} chmod 600 #{destination}"
# end
