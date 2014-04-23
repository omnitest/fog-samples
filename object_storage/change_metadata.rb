#!/usr/bin/env ruby

# This example demonstrates retrieve an object
# 
# Services used:
#   - [Create or Update Container Metadata](http://docs.rackspace.com/files/api/v1/cf-devguide/content/POST_updateacontainermeta_v1__account___container__containerServicesOperations_d1e000.html)
#   - [Create or Update Object Metadata](http://docs.rackspace.com/files/api/v1/cf-devguide/content/POST_updateaobjmeta_v1__account___container___object__objectServicesOperations_d1e000.html)

require 'fog'
require 'fileutils'
require File.expand_path('../../sample_helper', __FILE__)

def print_metadata(object)
  object.metadata.each_pair do |key, value|
    puts "\t#{key}: #{value}"
  end
  puts "\n"
end

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => SampleHelper.rackspace_username,
  :rackspace_api_key    => SampleHelper.rackspace_api_key,
  :rackspace_region => SampleHelper.rackspace_region, # e.g. ord
  :rackspace_auth_url   => SampleHelper.authentication_endpoint
})

# prompt for directory name
directory_name = SampleHelper.get_required_option 'REMOTE_DIRECTORY', 'Enter the name of the container you wish to download from'
directory = service.directories.get directory_name
raise 'The specified container does not exist.' if directory.nil?

object_key = SampleHelper.get_required_option 'REMOTE_FILE', 'Enter the path within the container of the object you wish to download'
file = directory.files.get object_key

# initial metadata
puts "Initial Container Metadata\n"
print_metadata directory

# adding metadata
puts "Adding Container Metadata"
directory.metadata["environment"] = "demo"
directory.save
print_metadata directory

# update metadata
puts "Updating Container Metadata"
directory.metadata["environment"] = "test"
directory.save
print_metadata directory

# initial metadata
puts "Initial File Metadata\n"
print_metadata file

# adding metadata
puts "Adding File Metadata"
file.metadata["preview"] = "true"
file.save
print_metadata file

# update metadata
puts "Updating File Metadata"
file.metadata["preview"] = "false"
file.save
print_metadata file

puts "To delete the directory and file please execute the delete_directory.rb script\n\n"