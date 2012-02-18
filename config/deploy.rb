require 'bundler/capistrano'

default_environment['PADRINO_ENV'] = 'production'
server "natsu.me", :app, :web
set :deploy_to, "/var/g.natsu.me"

set :use_sudo, false
set :application, "nyazo"
set :user, ENV['DEPLOY_USER']
set :scm, :git
set :repository, "git://github.com/natsumesou/gyazo_server.git"
set :branch, "origin/master"

set :shared_dir, "shared"
set :shared_children, %w(log vendor tmp)
set :current_dir, "current"

default_run_options[:shell] = 'bash'

set(:current_path) { File.join(deploy_to, current_dir) }
set(:shared_path) { File.join(deploy_to, shared_dir) }
set(:current_release) { File.join(deploy_to, current_dir) }
set(:bundle_dir) { File.join(shared_path, 'vendor/bundle') }
set :bundle_without, [:development, :test, :local]

namespace :deploy do
  desc "DEPLOY"
  task :default do
    update
    restart
  end

  desc "Setup a project deployment"
  task :setup do
    dirs = [current_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')}"
    
    run "git clone #{repository} #{current_path}"
  end

  desc "update repository"
  task :update do
    transaction do
      run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
      shared_children.map do |path|
        run "rm -rf #{current_path}/#{path} && \
             ln -s #{shared_path}/#{path} #{current_path}/#{path}"
      end
      bundle.install
    end
  end

  desc "restart padrino project"
  task :restart do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
