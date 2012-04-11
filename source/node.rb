require 'rubygems'
require 'bundler/setup'
require 'net/ssh'
require 'sinatra/config_file'
config_file 'config/config.yml'
# A `Node` represents one node in the Vislab cluster.
# There are methods to start, stop and querying status infos.

class Node

	def initialize(ip = "1")
		@ip = ip
		@ipmi_ip = settings.ipmi["ip_offset"].to_i + ip
		@status = false
	end

	# Starts the node via ipmi
	def start
		# puts "Starting #{@ip} ..."
		system ipmi_command + " chassis power on"
	end

	# Stops the node via ipmi
	def stop
		# puts "Stopping #{@ip} ..."
		system ipmi_command + " chassis power soft"
	end

	# Restarts the node via ipmi
	def restart
		# puts "Restarting #{@ip} ..."
		system ipmi_command + " chassis power cycle"
	end

	# Queries the power status of the node via ipmi
	def status
		# puts "Status #{@ip} ..."
		output = `#{ipmi_command} chassis power status`
		# p output
		if output =~ /on/
			@status = true
		elsif output =~ /off/
			@status = false
		end
	end

	# Pings the nodes network interface
	def ping
		puts "Pinging #{@ip} ..."
		system "ping #{ip_string}"
	end

	# Returns its ip
	def ip
		@ip
	end

	# Returns the complete ip as a string. Ips are in the *34* subnet.
	def ip_string
		"#{settings.subnet}.#{settings.nodes_ip_offset + @ip}"
	end

	# Returns the complete ipmi address as a string.
	# Ipmi cards are in the *71* subnet.
	def ipmi_ip_string
		"#{settings.ipmi['subnet']}." + @ipmi_ip.to_s
	end

	# Returns the IPMI command with credentials
	def ipmi_command
		"ipmitool -H " + ipmi_ip_string + " -U #{settings.ipmi['user']} -P #{settings.ipmi['pw']}"
	end

	# Executes a ssh command
	def execute_ssh_command(command)
		result = ''
		Net::SSH.start(ip_string, settings.ssh["user"]) do |ssh|
			result = ssh.exec!("cmd /c #{command}")
		end
		result
	end
end