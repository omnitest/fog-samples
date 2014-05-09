#!/usr/bin/env ruby

# This example demonstrates how to manage volumes on an existing server instance.
# 
# Services used:
#   - [Attach Volume to Server](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Attach_Volume_to_Server.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

#create Next Generation Cloud Server service
compute_service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

cbs_service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username => SampleHelper.rackspace_username,
  :rackspace_api_key  => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# retrieve list of servers
servers = compute_service.servers

# prompt user for server
server = SampleHelper.select_server(servers)

# prompt for volume name
volume_name = SampleHelper.get_required_option 'VOLUME_NAME', "Enter Volume Name"

puts "\nCreating Volume\n"
volume = cbs_service.volumes.create(:size => 100, :display_name => volume_name)

puts "\nAttaching volume\n"
attachment = server.attach_volume volume

volume.wait_for(600)  do
  print "."
  STDOUT.flush
  attached?
end

puts "\nVolume #{volume.display_name} has been attached to #{server.name} on device #{attachment.device}\n\n"
puts "To detach volume please execute the detach_volume.rb script\n\n"
