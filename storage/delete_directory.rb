#!/usr/bin/env ruby

# This example demonstrates deleting a container with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
  })

# retrieve directories
directories = service.directories

# prompt for directory
directory = select_directory(directories)

puts "\nNow deleting #{directory.key}"

# delete files if necessary
directory.files.each do |f|
  puts "\tDeleting file #{f.key}"
  f.destroy
end

# delete directory
directory.destroy

puts "\tDone\n\n"
