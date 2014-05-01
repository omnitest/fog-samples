#!/usr/bin/env ruby

# This example demonstrates creating a container with the Rackpace Open Cloud

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


# prompt for directory name
directory_name = get_user_input "\nEnter name of directory to create"

# create directory
directory = service.directories.create :key => directory_name

# reload directory to refresh information
directory.reload

puts "\n Directory #{directory.key} was created."
puts "To delete the container please execute the delete_directory.rb script\n\n"


