#!/usr/bin/env ruby

# This example demonstrates creating an auto scaling group with the Rackpace Open Cloud

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

# create Next Generation Cloud Server service to get list of flavors
compute_service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => rackspace_region,
  :rackspace_auth_url   => auth_url
})

# UUID for INTERNET
INTERNET = '00000000-0000-0000-0000-000000000000'

# UUID for Rackspace's service net
SERVICE_NET = '11111111-1111-1111-1111-111111111111'

# prompt for scaling group name
scaling_group_name = opts['--group']

# prompt for cool down period
cooldown = opts['--cooldown'].to_i

# prompt for miniumum number of entities
min_entities = opts['--min-entitites'].to_i

# prompt for max number of entities
max_entities = opts['--max-entities'].to_i

# retrieve list of images from computer service
print "Loading available server images...."
images = compute_service.images.all
puts "[DONE]"

# prompt for server image
image = images.find {|i| i.name == opts['--image']}
abort "\nPlease select an image. Available images: #{images.map(&:name)}" if image.nil?

# pick first server flavor
flavor = compute_service.flavors.first

attributes = {
  :server_name => "autoscale_server",
  :image => image,
  :flavor => flavor,
  :networks => [INTERNET, SERVICE_NET],
  :personality => [
    {
      "path" => "/root/.csivh",
      "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
    }
  ],
  :max_entities => max_entities,
  :min_entities => min_entities,
  :cooldown => cooldown,
  :name => scaling_group_name,
  :metadata => { "created_by" => "autoscale sample script" },
  :launch_config_type => :launch_server
}

# Use builder to create group
group = Fog::Rackspace::AutoScale::GroupBuilder.build(auto_scale_service, attributes)

# save the built group
group.save

puts "\nScaling Group #{scaling_group_name} (#{group.id}) was created!"
puts "State: #{group.state}"
