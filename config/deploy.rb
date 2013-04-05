require 'bundler/capistrano'

set :application, "senior-project"
# Repository information
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :repository,  "git@github.com:hathaway/senior-project.git"

# Information for the user on the server to use for deployments
set :user, "deployer"
set :group, "staff"
set :use_sudo, false
ssh_options[:forward_agent] = true 

role :web, "web.hathaway.cc"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# rbenv specific settings
set :default_environment, { 'PATH' => "/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH" }
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end