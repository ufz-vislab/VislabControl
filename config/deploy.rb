require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"
set :rvm_ruby_string, 'default@vislab-control'        # Or whatever env you want it to run in.
set :rvmpath, '~/.rvm'
set :rvm_bin_path, '~/.rvm/bin'

load 'deploy' if respond_to?(:namespace)

set :application, "vislab-control"
set :repository, "git@vismac02.intranet.ufz.de:vislab/vislab-control.git"
set :scm, :git

set :user, "pow"
set :use_sudo, false
set :host_name, "141.65.34.28"
set :deploy_to, "/Users/#{user}/apps/#{application}"
set :deploy_via, :copy

role :app, "#{host_name}"
role :web, "#{host_name}"

set :runner, user
set :admin_runner, user

namespace :deploy do
	task :start, :roles => [:app, :web] do
		run "cd #{deploy_to}/current && powder link #{application} --force && powder up"
	end

	task :stop, :roles => [:app, :web] do
		run "cd #{deploy_to}/current && powder unlink && powder down"
	end

	task :restart, :roles => [:app, :web] do
		run "cd #{deploy_to}/current && touch tmp/restart.txt && powder restart"
	end

end