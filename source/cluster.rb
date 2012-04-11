require './source/node.rb'
require './source/nodeset.rb'

# The `Cluster` class has nodes and nodesets and can control them.
class Cluster

	# Creates the node instances from a given ip list
	def initialize(ips)
		@nodes = []
		ips.each do |ip|
			@nodes << Node.new(ip)
		end

		@node_sets = []
		# Array of pairs of a VRED version (e.g. 2.5) and its corresponding
		# install path
		@vred_versions = []
	end

	# Returns the nodes
	def nodes
		@nodes
	end

	# Returns one node with the given (short) ip
	def node(ip)
		@nodes.each do |node|
			return node if node.ip == ip
		end
	end

	# Returns the node with the given ip
	def node_from_long_ip(ip)
		last_ip = /[0-9]*$/.match(ip)
		node(Integer(last_ip[0]) - 100 )
	end

	# Creates a nodeset consisting of a name and a list of ips.
	def create_node_set(name, ips)
		puts "cluster creating nodeset"

		#@node_sets << Array.new()
		nodes_in_set = []
		ips.each do |ip|
			nodes_in_set << node(ip)
			# @node_sets.last << node(ip)
		end
		@node_sets << Nodeset.new(name, nodes_in_set)
	end

	# Returns the node set with the given name
	def node_set(name)
		@node_sets.each do |node_set|
			if node_set.name == name
				puts "Found"
				return node_set
			end
		end
	end

	# Returns the nodesets
	def nodesets
		@node_sets
	end

	## Commands ##

	### Global ###

	# Starts all nodes
	def start
		@nodes.each do |node|
			node.start
		end
	end

	# Restarts all nodes
	def restart
		@nodes.each do |node|
			node.restart
		end
	end

	# Stops all nodes
	def stop
		@nodes.each do |node|
			node.stop
		end
	end

	# Queries the status of all nodes
	def status
		@nodes.each do |node|
			node.status
		end
	end

	### Node ###

	# Starts the node with the given ip
	def start_node(ip)
		node_from_long_ip(ip).start
	end

	# Restarts the node with the given ip
	def restart_node(ip)
		node_from_long_ip(ip).restart
	end

	# Stops the node with the given ip
	def stop_node(ip)
		node_from_long_ip(ip).stop
	end

	### Nodeset

	# Starts the nodeset with the given name
	def start_nodeset(name)
		node_set(name).start
	end

	# Restarts the nodeset with the given name
	def restart_nodeset(name)
		node_set(name).restart
	end

	# Stops the nodeset with the given name
	def stop_nodeset(name)
		node_set(name).stop
	end

	### VRED

	def add_vred_version(version, path, bit_type)
		@vred_versions.push( { "version" => version, "path" => path, "bit_type" => bit_type } )
	end

	# Sets VRED version on all nodes
	def set_vred_version(version)

		vred_version_to_start = get_vred_version(version)

		# Stop
		@vred_versions.each do |vred_version|
			if vred_version != vred_version_to_start
				stop_vred_version (vred_version)
			end
		end

		# Start
		start_vred_version(vred_version_to_start)

	end

	# Starts VRED version
	def start_vred_version(vred_version)
		puts "Starting #{vred_version["version"]}"
		@nodes.each do |node|
			puts node.execute_ssh_command(
				"cd #{vred_version["path"]} && \"Activate Cluster Service.lnk\"")
		end
		#puts "cd #{vred_version["path"]} && \"Activate Cluster Service.lnk\""
	end

	# Stops VRED version
	def stop_vred_version(vred_version)
		puts "Stopping #{vred_version["version"]}"
		@nodes.each do |node|
			puts node.execute_ssh_command(
				"cd #{vred_version["path"]} && \"Deactivate Cluster Service.lnk\"")
		end
		#puts "cd #{vred_version["path"]} && \"Deactivate Cluster Service.lnk\""
	end

	def get_vred_version(version)
		@vred_versions.each do |vred_version|
			if vred_version["version"] == version
				return vred_version
			end
		end
	end
end