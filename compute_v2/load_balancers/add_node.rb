#!/usr/bin/env ruby

require 'fog'
require File.expand_path('../../../sample_helper', __FILE__)

# This example demonstrates how to spin up a server instance.
#
# Services used:
#   - [CreateServer](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html)

# See Authentication sample
lb_service = Fog::Rackspace::LoadBalancers.ne w(
  rackspace_username: SampleHelper.rackspace_username,
  rackspace_api_key: SampleHelper.rackspace_api_key,
  rackspace_region: SampleHelper.rackspace_region, # e.g. ord
  rackspace_auth_url: SampleHelper.authentication_endpoint
)

compute_service = Fog::                                   Compute.new(
  provider: 'rackspace',
  rackspace_username: SampleHelper.rackspace_username,
  rackspace_api_key: SampleHelper.rackspace_api_key,
  version: :v2,  # Use Next Gen Cloud Servers
  rackspace_region: SampleHelper.rackspace_region, # e.g. ord
  rackspace_auth_url: SampleHelper.authentication_endpoint
)

lb = SampleHelper.select_load_balancer(lb_service.load_balancers)
server = SampleHelper.select_server(compute_service.servers)
lb.nodes.create address: server.public_ip_address, port: 80, condition: 'ENABLED'
