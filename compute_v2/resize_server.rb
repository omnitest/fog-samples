#!/usr/bin/env ruby

# This example demonstrates how to resize an existing server instance.
# 
# Services used:
#   - [ResizeServer](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Resize_Server-d1e3707.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

#create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

#retrieve list of servers
servers = service.servers

#prompt user for server
server = SampleHelper.select_server(servers)

# retrieve list of avaliable flavors
flavors = service.flavors

# prompt user for flavor
selected_flavor = SampleHelper.select_flavor(flavors)

# resize server
server.resize selected_flavor.id

puts "\n"

# wait for the resize process to start
server.wait_for { ready?('RESIZE') }

begin
  # Check every 5 seconds to see if server is in the VERIFY_RESIZE state.
  # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
  server.wait_for(1200, 5) do
    print "."
    STDOUT.flush
    ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR'])
  end
  puts "[DONE]\n\n"

  puts "Server Has Been Successfully Resized!"
  action = get_user_input "Press 'C' To Confirm Or 'R' to Revert Resize (R/C)"

  case action.upcase
  when 'C'
    puts "\nConfirming Resize Operation"
    server.confirm_resize
  when 'R'
    puts "\nReverting Resize Operation"
    server.revert_resize
  else
    puts "\nUnrecognized Input. Exiting."
  end

rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"

  puts "This server is currently #{server.progress}% into the resize process and is taking longer to complete than expected."
  puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
end