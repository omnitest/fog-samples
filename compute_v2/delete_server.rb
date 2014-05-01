#!/usr/bin/env ruby

# This example demonstrates how to delete servers with Fog and the Rackspace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

#create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord #Use Chicago Region
})

#retrieve list of servers
servers = service.servers

#prompt user for server
server = select_server(servers)

#destroy server
server.destroy

puts "\nServer #{server.name} has been destroyed\n"

