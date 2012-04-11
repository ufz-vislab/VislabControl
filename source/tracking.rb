# The `Tracking` class can communicate (via TCP) to a DTrack control server from
# AR-Tracking.
class Tracking
	# Must be initialized with the ip of the host and the port on which the
	# control server is listening to. An array of configuration names can be
	# specified. See the dtrack_readme.txt for more infos
	def initialize(ip, port, configs)
		@ip = ip
		@port = port
		@configs = configs
	end

	def configs
		@configs
	end

	# Starts the tracking
	def start
		send_command('dtrackcontrol start') # Starts the DTrack application
		send_command('dtrack 10 3')         # Starts the measurements
		send_command('dtrack 31')           # Output data to the network
	end

	# Stops the tracking
	def stop
		send_command('dtrack 32')           # Stop outputting data to the network
		send_command('dtrack 10 0')         # Stops the measurements
		send_command('dtrackcontrol stop')  # Stops the DTrack application
	end

	# Loads a configuration
	def load_configuration(name)
		stop
		sleep 0.5
		send_command("dtrackcontrol setup #{name}") # Switches config
		sleep 0.5
		start
	end

	# Sends a string via TCP to the given ip and port
	def send_command(command_string)
		TCPSocket.open(@ip, @port) {|s|
			s.send(command_string, 0)
		}
	end
end