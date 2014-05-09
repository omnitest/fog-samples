#!/usr/bin/env ruby

# This example demonstrates how create a container
# 
# Services used:
#   - [Create Container](http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createcontainer_v1__account___container__containerServicesOperations_d1e000.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# prompt for directory name
directory_name = SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter name of directory to create'

# create directory
directory = service.directories.create :key => directory_name, :public => true

# reload directory to refresh information
directory.reload

puts "\n Directory #{directory.key} was created."
puts "To delete the container please execute the delete_container.rb script\n\n"