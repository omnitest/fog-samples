#!/usr/bin/env ruby

# This example demonstrates deleting an auto scaling group with the Rackpace Open Cloud

require 'fog'
require 'fog/rackspace/models/auto_scale/group_builder'

require "docopt"
doc = <<DOCOPT
This example demonstrates adding a policy to an auto scaling group with the Rackpace Open Cloud

Usage: #{__FILE__} [options]

Options:
  --user=<user>
      Rackspace username. Default: RAX_USERNAME environment variable or from ~/.fog.
  --api-key=<api_key>
      Rackspace API key. Default: RAX_API_KEY environment variable or from ~/.fog.
  --auth-url=<auth_url>
      Rackspace auth URL. Default: OS_AUTH_URL environment variable or from ~/.fog.
  --region=<region>
      Rackspace region. Default: RAX_REGION environment variable.
  --group=<group>
      Autoscale group name.
  --image=<image>
      Rackspace server image name.
  -h --help
      Show this screen.

Examples:
  #{__FILE__} --group=my_group --image="CoreOS (Stable)"

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

# create auto scaling service
auto_scale_service = Fog::Rackspace::AutoScale.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => rackspace_region,
  :rackspace_auth_url   => auth_url
})

# retrieve list of scaling groups
groups = auto_scale_service.groups
abort "\nThere are not any scaling groups in the Chicago region. Try running create_scaling_group.rb\n\n" if groups.empty?
group = groups.find {|g| g.group_config.name == opts['--group']}
abort "\nPlease select a scaling group. Available groups: #{groups.map{ |g| g.group_config.name }}" if group.nil?

# min_entities and max_entities must be 0 before deleting group
config = group.group_config
config.min_entities = 0
config.max_entities = 0
config.save

# delete group
group.destroy

puts "\nScaling Group '#{config.name}' has been destroyed\n\n"
