require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/config_file'
require 'mustache/sinatra'

require './source/cluster'
require './source/tracking'

# App configuration
config_file 'config/config.yml'

$cluster = Cluster.new(settings.nodes)
settings.node_sets.each do |node_set|
	$cluster.create_node_set(node_set["name"], node_set["nodes"])
end

settings.vred_versions.each do |vred_version|
	$cluster.add_vred_version(vred_version["name"], vred_version["path"], vred_version["arch"])
end

$tracking = Tracking.new(settings.tracking["ip"], settings.tracking["port"], settings.tracking["configs"])

class App < Sinatra::Base
	register Mustache::Sinatra
	require './views/layout'

	# use Rack::Auth::Basic, "Restricted Area" do |username, password|
  	# 	[username, password] == ['admin', 'admin']
	# end


	set :mustache, {
		:views => './views',
		:templates => 'templates/'
	}

	# Global
	get '/' do
		$cluster.status
		@title = "Status queried"
		mustache :index
	end

	get '/start' do
		$cluster.start
		@title = "Cluster started"
		mustache :index
	end

	get '/restart' do
		$cluster.restart
		@title = "Cluster restarted"
		mustache :index
	end

	get '/stop' do
		$cluster.stop
		@title = "Cluster stopped"
		mustache :index
	end

	# Node
	get '/start/:ip' do
		$cluster.start_node(params[:ip])
		@title = "Node with ip = #{params[:ip]} started"
		@ip = params[:ip]
		mustache :index
	end

	get '/restart/:ip' do
		$cluster.restart_node(params[:ip])
		@title = "Node with ip = #{params[:ip]} restarted"
		@ip = params[:ip]
		mustache :index
	end

	get '/stop/:ip' do
		$cluster.stop_node(params[:ip])
		@title = "Node with ip = #{params[:ip]} stopped"
		@ip = params[:ip]
		mustache :index
	end

	# Nodeset
	get '/nodeset/start/:name' do
		$cluster.start_nodeset(params[:name])
		@title = "Nodeset #{params[:name]} started"
		mustache :index
	end

	get '/nodeset/restart/:name' do
		$cluster.restart_nodeset(params[:name])
		@title = "Nodeset #{params[:name]} restarted"
		mustache :index
	end

	get '/nodeset/stop/:name' do
		$cluster.stop_nodeset(params[:name])
		@title = "Nodeset #{params[:name]} stopped"
		mustache :index
	end

	# Tracking
	get '/tracking/start' do
		$tracking.start
		@title = "Tracking started"
		mustache :index
	end

	get '/tracking/stop' do
		$tracking.stop
		@title = "Tracking stopped"
		mustache :index
	end

	get '/tracking/config/:name' do
		$tracking.load_configuration(params[:name])
		@title = "Tracking configuration changed. Please start the tracking again!"
		mustache :index
	end

	# VRED
	get '/vred/:version' do
		$cluster.set_vred_version(params[:version])
		@title = "VRED #{params[:version]} set."
		mustache :index
	end
end