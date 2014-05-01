#!/usr/bin/env ruby

# This example demonstrates deleting Cloud Block Storage volume with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Cloud Block Storage service
service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
})

# retrieve list of volumes
volumes = service.volumes

# prompt user for volume
volume = select_volume(volumes)

# delete volume
volume.destroy

puts "\nVolume #{volume.display_name} is being destroyed.\n\n"
