# A `Nodeset` represents a list of nodes in the Vislab cluster.
# There are methods to start, stop and querying status infos.
class Nodeset
	# Must be initialized with a name and an array of ips
	def initialize(name, ips)
		@nodes = []
		ips.each do |ip|
			@nodes << ip
		end
		@name = name
		puts "Created nodeset #{@name}"
	end

	def name
		@name
	end

	# Starts all nodes in the nodeset
	def start
		puts "Starting node set #{@name}"
		@nodes.each do |node|
			node.start
		end
	end

	# Stops all nodes in the nodeset
	def stop
		puts "Stopping node set #{@name}"
		@nodes.each do |node|
			node.stop
		end
	end

	# Restarts all nodes in the nodeset
	def restart
		puts "Restarting node set #{@name}"
		@nodes.each do |node|
			node.restart
		end
	end
end