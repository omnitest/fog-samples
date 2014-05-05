#!/usr/bin/env ruby

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# This example demonstrates how to spin up a server instance.
# 
# Services used:
#   - [CreateServer](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html)

identity = Fog::Rackspace::Identity.new({
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

username = SampleHelper.get_required_option 'SECONDARY_USER', "\nEnter a username for an API key reset"
user = identity.users.find { |user| user.username == username }

user.destroy