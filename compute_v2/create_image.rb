#!/usr/bin/env ruby

# This example demonstrates creating a server image with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord #Use Chicago Region
})

# retrieve list of servers
servers = service.servers

# prompt user for server
server = select_server(servers)

# prompt user for image name
image_name = get_user_input "Enter Image Name"

# creates image for server
server.create_image image_name

puts "\nImage #{image_name} is being created for server #{server.name}.\n\n"
puts "To delete the image please execute the delete_image.rb script\n\n"


