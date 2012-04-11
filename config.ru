require 'bundler/setup'
require 'sinatra'
require './source/app'

use Rack::ShowExceptions

# Enable output logging
enable :logging, :dump_errors, :raise_errors
set :environment, :development

# Log to file
log = File.new("sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run App.new