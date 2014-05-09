#!/usr/bin/env ruby

require 'fog'
require File.expand_path('../../../sample_helper', __FILE__)

# This example demonstrates how to spin up a server instance.
# 
# Services used:
#   - [CreateServer](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html)

# See Authentication sample
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

net_label = SampleHelper.get_required_option 'NETWORK_LABEL', "\nEnter a label for the network to create"

#create private network called my_private_net with an ip range between 192.168.0.1 - 192.168.0.255 (Note this will accept IPv6 CIDRs as well)
net = service.networks.create :label => net_label, :cidr => '192.168.0.0/24'