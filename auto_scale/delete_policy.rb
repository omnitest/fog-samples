#!/usr/bin/env ruby

require 'fog'
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
  --policy=<policy>
      Autoscale policy name.
  --cooldown=<cooldown>
      Cooldown period in seconds.
  --change=<change>
      Change increment.
  -h --help
      Show this screen.

Examples:
  #{__FILE__} --group=my_group --policy=my_policy --cooldown=5 --change=1

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

# retrieve list of policies for group
policies = group.policies
abort "\nThere are no policies in the #{group.name} group. Try running add_policy.rb\n\n" if policies.empty?
policy = policies.find {|p| p.name == opts['--policy']}
abort "\nPlease select a policy. Available policies: #{policies.map(&:name)}" if policy.nil?

# delete policy
policy.destroy

puts "\nPolicy '#{policy.name}' has been destroyed\n\n"
