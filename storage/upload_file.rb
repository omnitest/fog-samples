#!/usr/bin/env ruby

# This example demonstrates how create a container
# 
# Services used:
#   - [Create or Update Object](http://docs.rackspace.com/files/api/v1/cf-devguide/content/PUT_createobject_v1__account___container___object__objectServicesOperations_d1e000.html)

require 'fog'
require File.expand_path('../../sample_helper', __FILE__)

Excon.defaults[:ssl_verify_peer] = false

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# prompt for directory name
directory_name = SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter name of the target container'
directory = service.directories.get directory_name
raise 'The specified container does not exist.' if directory.nil?

# upload file
upload_file = SampleHelper.get_option('UPLOAD_FILE') || 'fixtures/lorem.txt'
file = directory.files.create :key => 'sample.txt', :body => File.open(upload_file, "r")

puts "You should be able to view this file via CDN at #{file.public_url}"
puts "To delete the container and associated file please execute the delete_container.rb script\n\n"