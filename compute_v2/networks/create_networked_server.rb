#!/usr/bin/env ruby

require 'fog'
require File.expand_path('../../../sample_helper', __FILE__)

# This example demonstrates how to spin up a server instance.
# 
# Services used:
#   - [CreateServer](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html)

# UUID for INTERNET
INTERNET = '00000000-0000-0000-0000-000000000000'

# UUID for Rackspace's service net
SERVICE_NET = '11111111-1111-1111-1111-111111111111'

# See Authentication sample
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# pick the first flavor
flavor = service.flavors.find {|flavor| flavor.name == '1 GB Performance' }

# pick the first Ubuntu image we can find
image = service.images.find {|image| image.name =~ /Ubuntu/}

# prompt for server name
server_name = SampleHelper.get_required_option 'SERVER_NAME', "\nEnter Server Name"

net_label = SampleHelper.get_required_option 'NETWORK_LABEL', "\nEnter a label for the network to delete"
net = service.networks.find{|n| n.label == net_label}

# create server
server = service.servers.create :name => server_name,
                                :flavor_id => flavor.id,
                                :image_id => image.id,
                                :metadata => { 'fog_sample' => 'true'},
                                :networks => [net.id, INTERNET]

puts "\nNow creating server '#{server.name}' connected the the Internet and '#{net.label}'\n"

begin
  # Check every 5 seconds to see if server is in the active state (ready?).
  # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
  server.wait_for(600, 5) do
    print "."
    STDOUT.flush
    ready?
  end

  puts "[DONE]\n\n"

  puts "The server has been successfully created, to login onto the server:\n\n"
  puts "\t ssh #{server.username}@#{server.public_ip_address}\n\n"

rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"

  puts "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
  puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
end

puts "The #{server.username} password is #{server.password}\n\n"
puts "To delete the server and private network please execute the delete_network.rb script\n\n"