#!/usr/bin/env ruby

require 'fog'
require "docopt"
doc = <<DOCOPT
This example demonstrates creating a new domain on Rackspace DNS.

Usage: #{__FILE__} [options]
Example: #{__FILE__} --domain-name=foo.example.com --admin-email=admin@example.com

Options:
  --user=<user>
      Rackspace username. Default: RAX_USERNAME environment variable or from ~/.fog.
  --api-key=<api_key>
      Rackspace API key. Default: RAX_API_KEY environment variable or from ~/.fog.
  --auth-url=<auth_url>
      Rackspace auth URL. Default: OS_AUTH_URL environment variable or from ~/.fog.
  --region=<region>
      Rackspace region. Default: RAX_REGION environment variable.
  --domain-name=<domain_name>
      Domain name to create.
  --admin-email=<email>
      DNS Admin email address.
  -h --help
      Show this screen.

DOCOPT

begin
  opts = Docopt::docopt(doc)
rescue Docopt::Exit => e
  abort e.message
end

rackspace_username = opts['--user'] || ENV['RAX_USERNAME'] || Fog.credentials[:rackspace_username]
rackspace_api_key = opts['--api-key'] || ENV['RAX_API_KEY'] || Fog.credentials[:rackspace_api_key]
auth_url = opts['--auth-url'] || ENV['RAX_AUTH_URL']
rackspace_region = opts['--region'] || ENV['RAX_REGION']

service = Fog::DNS.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => rackspace_region, # e.g. ord
  :rackspace_auth_url   => auth_url
})

domain_name = opts['--domain-name']
admin_email = opts['--admin-email']

service.zones.create :domain => domain_name, :email => admin_email

