class App
  module Views
	class Index < Layout

		def initialize
			@cluster = $cluster
		end

		def array
			my_array = [ ]
			@cluster.nodes.each do |node|
				h = { :ip => node.ip_string, :ipmi => node.ipmi_ip_string, :status => node.status }
				my_array << h
			end
			#my_array = [ { :datum => 'one', :bla => 'bla' }, { :datum => 'two' }, { :datum => 'three' } ]
			return my_array
		end

		def nodeset_array
			my_nodeset_array = []
			@cluster.nodesets.each do |nodeset|
				h = { :name => nodeset.name }
				my_nodeset_array << h
			end
			return my_nodeset_array
		end

		def tracking_configs
			my_configs_array = []
			$tracking.configs.each do |config|
				h = { :name => config.to_str }
				my_configs_array << h
			end
			return my_configs_array
		end
	end
  end
end