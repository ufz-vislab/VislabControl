require 'rubygems'
require 'rake'

desc "Runs rocco document generation"
task :docs do
	system "bundle exec rocco -o docs $(find ./source -name '*.rb')"
end

desc "Cleanup generated files"
task :clean do
	system "rm -r docs"
end

desc "Deploys to the server via Capistrano"
task :deploy do
	system "bundle exec cap deploy:upload FILES='config/config.yml'"
	system "bundle exec cap deploy"
end