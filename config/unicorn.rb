# Set your full path to application.
app_dir = File.expand_path('../../', __FILE__)
shared_dir = "#{app_dir}/../../shared"

# Fill path to your app
working_directory app_dir

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64

# Loging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
      p 'There was a problem happend during killing the workers'
    end
  end
end

after_fork { defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection }

before_exec { ENV['BUNDLE_GEMFILE'] = "#{app_dir}/Gemfile" }
