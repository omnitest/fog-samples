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

name = SampleHelper.get_required_option('LOAD_BALANCER_NAME', 'Select a name for the load balancer')

lb = lb_service.load_balancers.create name: name, protocol: 'HTTP',
                                      port: 80, # should not be required, see https://github.com/fog/fog/issues/2902
                                      virtual_ips: [{ type: 'PUBLIC' }], # also fog #2902
                                      nodes: [{ address: '1.1.1.1', port: 80, condition: 'ENABLED' }] # also fog #2902
lb.wait_for { ready? }
