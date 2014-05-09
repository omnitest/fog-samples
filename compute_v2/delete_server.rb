#!/usr/bin/env ruby

# This example demonstrates how to manage volumes on an existing server instance.
# 
# Services used:
#   - [Delete Volume Attachment](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Volume_Attachment.html)

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

# retrieve list of servers
servers = compute_service.servers

# prompt user for server
server = SampleHelper.select_server(servers)

servers.destroy server.id