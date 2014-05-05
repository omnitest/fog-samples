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

lb = SampleHelper.select_load_balancer(lb_service.load_balancers)

lb.wait_for { ready? }
lb.destroy
