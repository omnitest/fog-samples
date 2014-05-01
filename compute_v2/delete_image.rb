#!/usr/bin/env ruby

# This example demonstrates deleting a server image with the Rackpace Open Cloud

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

# retrieve list of images
images = service.images

# select all of the snapshot type images. base images are not user deletable
snapshot_images = images.select do |image|
  image.metadata["image_type"] == "snapshot"
end

# prompt user for image to delete
image = select_image(snapshot_images)

# delete image
image.destroy

puts "\n#{image.name} has been destroyed\n\n"

