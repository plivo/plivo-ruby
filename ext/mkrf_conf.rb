require 'rubygems'

# return an error if openssl isn't installed.
require 'openssl'

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   
f.write("task :default\n")
f.close
