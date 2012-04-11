require 'rubygems'
require 'rake'

desc "Runs rocco document generation"
task :docs do
	system "rocco -o docs $(find . -name '*.rb')"
	#system 'rocco', '-o', 'docs', './*.rb'
end

desc "Cleanup generated files"
task :clean do
	system 'rm', '-r', 'docs'
end