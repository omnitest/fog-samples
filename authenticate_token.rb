#!/usr/bin/env ruby

# This example demonstrates creating a server with the Rackpace Open Cloud

require 'fog'

service = Fog::Compute.new({
    :provider             => 'rackspace',
    :rackspace_username   => ENV['RAX_USERNAME'],
    :rackspace_api_key    => ENV['RAX_API_KEY'],
    :rackspace_region     => ENV['RAX_REGION'].downcase.to_sym,
    :rackspace_auth_url   => "#{ENV['OS_AUTH_URL']}/v2.0"
})

puts "Authenticated"
